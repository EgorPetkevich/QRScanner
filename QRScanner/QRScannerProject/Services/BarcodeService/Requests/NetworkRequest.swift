//
//  NetworkRequest.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import Foundation

enum NetworHTTPMethod: String {
    case get = "GET"
}

protocol NetworkRequest {
    associatedtype ResponseModel: Decodable
    
    var barcode: String { get }
    var url: URL { get }
    var method: NetworHTTPMethod { get }
}
