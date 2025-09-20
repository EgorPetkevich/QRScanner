//
//  NetworkService.swift
//  QRScanner
//
//  Created by George Popkich on 25.07.24.
//

import UIKit

final class NetworkService {
    
    func getImage (url: URL, complition: @escaping (UIImage?, String?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: url)
            let strContents = try? String(contentsOf: url)
            if let urlContents {
                complition(UIImage(data: urlContents), strContents)
            }else {
                complition(nil, strContents)
            }
        }
    }
    
    func getText(url: URL, complition: @escaping (String?) -> Void) {
        do {
            let content = try String(contentsOf: url)
            complition(content)
        } catch {
            print("[NetworkService]: Error -", error.localizedDescription)
            complition(nil)
        }
    }
    
    func openLink(url: URL) {
        if  UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("[NetworkService]: Error - cannot open URL")
        }
    }
    
}

extension NetworkService: QRCodeServiceNetworkServiceUseCaseProtocol {}

extension NetworkService: BarcodeServiceNetworkServiceUseCaseProtocol {}
