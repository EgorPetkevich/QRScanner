//
//  ProductNameRequest.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import Foundation

///{
/// "code": "3017624010701",
/// "product": {
///        "nutrition_grades": "e",
///        product_name": "Nutella"
/// },
/// "status": 1,
/// "status_verbose": "product found"
///}


struct ProductNameResponse: Decodable {
    let code: String
    let product: ProductNameDetails
}

struct ProductNameDetails: Decodable {
    let productName: String
    
    private enum CodingKeys: String, CodingKey {
        case productName = "product_name"
    }
}

struct ProductNameRequest: NetworkRequest {
    
    typealias ResponseModel = ProductNameResponse
    
    var barcode: String
    
    var url: URL {
        let baseUrl = ApiPaths.productName
        let parameters = "fields=product_name"
        return URL(string: baseUrl + "/" + barcode + "?" + parameters)!
    }
    
    var method: NetworHTTPMethod { .get }
    
}
