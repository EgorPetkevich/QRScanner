//
//  NetworkSessionProvider.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import Foundation

final class NetworkSessionProvider {
    
    func send<Request: NetworkRequest>(request: Request,
                                       complition: @escaping
                                       (Request.ResponseModel) -> Void,
                                       decodeError: @escaping() -> Void) {
        
        let urlRequest = request.url
        
        URLSession.shared.dataTask(with: urlRequest) { responseData,
            response,
            error in
            if let error {
                print("[\(NetworkSessionProvider.self)]: Error -", error.localizedDescription)
                decodeError()
            } else if let responseData,
                      let responseModel = try? JSONDecoder()
                .decode(Request.ResponseModel.self, from: responseData) {
                complition(responseModel)
            } else {
                print("[NetworkLayaer]: Decode error to type \(Request.ResponseModel.self)")
                decodeError()
            }
        }.resume()
    }
    
}

extension NetworkSessionProvider: BarcodeServiceSessionProviderUseCaseProtocol {}
