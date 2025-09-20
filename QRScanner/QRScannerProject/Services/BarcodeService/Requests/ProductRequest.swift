//
//  ProductRequest.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import Foundation

///
///{
///     "1": {
///       "sizes": {
///         "full": {
///           "w": 850,
///           "h": 1200
///         },
///         "100": {
///           "h": 100,
///           "w": 71
///         },
///         "400": {
///           "h": 400,
///           "w": 283
///         }
///       },
///       ...
///     },
///     "front_fr": {
///         ...
///    }
///   }
///

struct ProductResponseModel: Decodable {
    let product: ProductDetails

    struct ProductDetails: Decodable {
        let code: String
        let images: [String: ImageDetails]

        struct ImageDetails: Decodable {
            let sizes: [String: ImageSize]
            let rev: String?
            let imgid: String?

            struct ImageSize: Decodable {
                let w: Int
                let h: Int
            }
        }
    }
}

struct ProductRequest: NetworkRequest {
    
    typealias ResponseModel = ProductResponseModel
    
    var barcode: String
    
    var url: URL {
        let baseURL = ApiPaths.productImage
        return URL(string: baseURL + "/" + barcode)!
    }
    
    var method: NetworHTTPMethod { .get }
    
}
