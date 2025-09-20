//
//  ApiPaths.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import Foundation


enum ApiPaths {
    static let productImage: String = "https://world.openfoodfacts.org/api/v2/product"
    static let productName: String = "https://world.openfoodfacts.org/api/v2/product"
    
    static func urlProduct(barcode: String) -> String {
        "https://world.openfoodfacts.org/product/" + barcode + "/cashews-alesto"
    }
}
