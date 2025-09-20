//
//  QRCodeService.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

protocol QRCodeServiceFileManagerServiceUseCaseProtocol {
    func saveQrCode(image: UIImage, with path: String)
}

protocol QRCodeServiceNetworkServiceUseCaseProtocol {
    func getImage (url: URL, complition: @escaping (UIImage?, String?) -> Void)
}

final class QRCodeService {
    
    typealias ComplitionHandler = (any DTODescription) -> Void
    typealias ErrorHandler = () -> Void
    
    private var networkService: QRCodeServiceNetworkServiceUseCaseProtocol
    private var fileManager: QRCodeServiceFileManagerServiceUseCaseProtocol
    
    init(networkService: QRCodeServiceNetworkServiceUseCaseProtocol,
         fileManager: QRCodeServiceFileManagerServiceUseCaseProtocol) {
        self.networkService = networkService
        self.fileManager = fileManager
    }
    
    func getQRCodeData(_ str: String, 
                       complitionHandler: @escaping ComplitionHandler,
                       errorHandler: ErrorHandler) {
        
        if let number = phoneDetector(phoneNumber: str,
                                      errorHandler: errorHandler) {
            let id = UUID().uuidString
            fileManager.saveQrCode(image: generateQRCode(from: str) ?? .Result.stubImage,
                                   with: id)
            
            let phoneDTO = PhoneQrCodeDTO(date: .now,
                                          id: id,
                                          title: str,
                                          phone: number)
            
            complitionHandler(phoneDTO)
            return
        }
        
        if let url = urlDetector(str: str, errorHandler: errorHandler) {
           
                self.networkService.getImage(url: url) {
                    [weak self] image, strContent in
                    let id = UUID().uuidString
                    self?.fileManager.saveQrCode(image: image ?? self?.generateQRCode(from: str) ?? .Result.stubImage,
                                                 with: id)
                    let urlDTO = UrlQrCodeDTO(date: .now,
                                              id: id,
                                              title: "str",
                                              strUrl: str)
                    DispatchQueue.main.async {
                       complitionHandler(urlDTO)
                }
            }
            return
        }
        
        if str != "" {
            let id = UUID().uuidString
            fileManager.saveQrCode(image: generateQRCode(from: str) ?? .Result.stubImage,
                                   with: id)
            let textDTO = TextQrCodeDTO(date: .now,
                                        id: id,
                                        title: str,
                                        text: str)
            complitionHandler(textDTO)
            return
        }
        
        errorHandler()
        
    }
    
    private func phoneDetector(phoneNumber: String, errorHandler: ErrorHandler
    ) -> String? {
        do {
            let detector =
            try NSDataDetector(types: NSTextCheckingResult
                .CheckingType
                .phoneNumber.rawValue)
            let match = detector.firstMatch(in: phoneNumber,
                                            range: NSRange(
                                                phoneNumber.startIndex...,
                                                in: phoneNumber))
            
            if
                match?.resultType == .phoneNumber,
                let number = match?.phoneNumber 
            {
                return number
            }
            
        } catch {
            errorHandler()
        }
        return nil
    }
    
    private func urlDetector(str: String, errorHandler: ErrorHandler) -> URL? {
        do {
            let detector =
            try NSDataDetector(types: NSTextCheckingResult
                .CheckingType
                .link
                .rawValue)
            let match = detector.firstMatch(in: str, 
                                            range: NSRange(
                                                str.startIndex...,
                                                in: str))
            
            if let match, match.resultType == .link, let url = match.url {
                return url
                
            }
        } catch {
            errorHandler()
        }
        return nil
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            guard
                let output = filter.outputImage?.transformed(by: transform)
            else { return nil }
            return UIImage(ciImage: output)
        }
        return nil
    }
    
}
