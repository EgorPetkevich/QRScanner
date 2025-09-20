//
//  BarcodeService.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import UIKit
import Storage

protocol BarcodeServiceFileManagerUseCaseProtocol {
    func saveBarcode(image: UIImage, with path: String)
}

protocol BarcodeServiceNetworkServiceUseCaseProtocol {
    func getImage(url: URL, complition: @escaping (UIImage?, String?) -> Void)
}

protocol BarcodeServiceSessionProviderUseCaseProtocol {
    func send<Request: NetworkRequest>(request: Request,
                                       complition: @escaping
                                       (Request.ResponseModel) -> Void,
                                       decodeError: @escaping() -> Void)
}

final class BarcodeService {
    
    private let service: BarcodeServiceNetworkServiceUseCaseProtocol
    private let session: BarcodeServiceSessionProviderUseCaseProtocol
    private let fileManager: BarcodeServiceFileManagerUseCaseProtocol
    
    init(service: BarcodeServiceNetworkServiceUseCaseProtocol,
         session: BarcodeServiceSessionProviderUseCaseProtocol,
         fileManager: BarcodeServiceFileManagerUseCaseProtocol) {
        self.service = service
        self.session = session
        self.fileManager = fileManager
    }
    
    func getBarcodeData(barcode: String,
                        completion: @escaping (any DTODescription) -> Void,
                        notFound: @escaping () -> Void) {
        
        self.getBarcodeProduct(barcode: barcode,
                               completion: { [weak self] image in
            
            self?.getBarcodeNameProduct(barcode: barcode,
                                        completion: { name in
                
                if name == nil && image == nil {
                    notFound()
                    return
                }
                
                let id = UUID().uuidString
                self?.fileManager.saveBarcode(image: image ?? .Result.stubImage, with: id)
                
                let barcodeDTO = BarcodeDTO(date: .now,
                                            id: id,
                                            title: name ?? "Product name not found",
                                            barcode: barcode,
                                            strUrl: ApiPaths.urlProduct(barcode: barcode))
                
                
                DispatchQueue.main.async {
                    completion(barcodeDTO)
                }
            }, decodeError: notFound)
        }, decodeError: notFound)
        
    }
    
    func getBarcodeProduct(barcode: String,
                           completion: @escaping (UIImage?) -> Void,
                           decodeError: @escaping() -> Void) {
        let productRequest = ProductRequest(barcode: barcode)
        
        session.send(request: productRequest, complition: { [weak self] response in
            guard
                let url = self?.getImageURL(with: response)
            else {
                completion(nil)
                return
            }
            
            self?.service.getImage(url: url) { image, _ in
                completion(image)
            }
            
        }, decodeError: decodeError)
    }
    
    func getBarcodeNameProduct(barcode: String,
                               completion: @escaping (String?) -> Void,
                               decodeError: @escaping() -> Void) {
        let productNameRequest = ProductNameRequest(barcode: barcode)
        
        session.send(request: productNameRequest, complition: { response in
            completion(response.product.productName)
        }, decodeError: decodeError)
    }
    
    func getImageURL(productData: [String: ProductResponseModel.ProductDetails.ImageDetails],
                     productCode: String,
                     imageNamePrefix: String = "front" ,
                     preferredLangCode: String,
                     fallbackLangCodes: [String] = ["en", "es", "fr"],
                     resolution: String = "full") -> URL? {
        
        if let url = getImageURL(for: productData,
                                 productCode: productCode,
                                 imageName: "\(imageNamePrefix)_\(preferredLangCode)",
                                 resolution: resolution) {
            return url
        }
        
        for lang in fallbackLangCodes {
            if let url = getImageURL(for: productData,
                                     productCode: productCode,
                                     imageName: "\(imageNamePrefix)_\(lang)",
                                     resolution: resolution) {
                return url
            }
        }
        
        return nil
    }
    
    private func getImageURL(with response: ProductRequest.ResponseModel?) -> URL? {
        if let productImage = response?.product.images,
           let productCode = response?.product.code {
            
            for (_, imageDetails) in productImage {
                if
                    let _ = imageDetails.sizes["400"],
                    let locale = NSLocale.current.language.languageCode?.identifier,
                    let url = self.getImageURL(productData: productImage,
                                               productCode: productCode,
                                               preferredLangCode: locale,
                                               resolution: "400") {
                    
                    print("[Image URL]: \(url)")
                    return url
                }
            }
            
            for (_, _) in productImage {
                if
                    let locale = NSLocale.current.language.languageCode?.identifier,
                    let url = self.getImageURL(productData: productImage,
                                               productCode: productCode,
                                               preferredLangCode: locale) {
                    
                    print("[Image URL]: \(url)")
                    return url
                }
            }
            
            for (imageName, _) in productImage {
                if let url = self.getImageURL(for: productImage,
                                              productCode: productCode,
                                              imageName: imageName,
                                              resolution: "400") {
                    print("[Image URL]: \(url)")
                    return url
                }
            }
            
            for (imageName, _) in productImage {
                if let url = self.getImageURL(for: productImage,
                                              productCode: productCode,
                                              imageName: imageName,
                                              resolution: "full") {
                    print("[Image URL]: \(url)")
                    return url
                }
            }
        }
        return nil
    }
    
    private func getImageURL(for productData: [String: ProductResponseModel.ProductDetails.ImageDetails],
                             productCode: String,
                             imageName: String,
                             resolution: String) -> URL? {
        guard let imageDetails = productData[imageName] else { return nil }
        
        let baseURL = "https://images.openfoodfacts.org/images/products"
        
        var folderName = productCode
        if folderName.count > 8 {
            folderName = folderName.replacingOccurrences(of: "(...)(...)(...)(.*)", with: "$1/$2/$3/$4", options: .regularExpression)
        }
        
        let preferredResolution = resolution
        
        var filename: String
        if let _ = imageName.range(of: "^[0-9]+$", options: .regularExpression) {
            let resolutionSuffix = preferredResolution == "full" ? "" : ".\(preferredResolution)"
            filename = "\(imageName)\(resolutionSuffix).jpg"
        } else {
            if let rev = imageDetails.rev {
                filename = "\(imageName).\(rev).\(preferredResolution).jpg"
            } else {
                return nil
            }
        }
        
        return URL(string: "\(baseURL)/\(folderName)/\(filename)")
    }
}
