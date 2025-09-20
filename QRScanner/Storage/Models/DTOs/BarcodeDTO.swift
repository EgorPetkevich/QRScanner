//
//  BarcodeDTO.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import CoreData

public struct BarcodeDTO: DTODescription {
    
    public typealias MO = BarcodeMO
    
    public static func fromMO(_ mo: BarcodeMO) -> BarcodeDTO? {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date,
            let barcode = mo.barcode,
            let strUrl = mo.strUrl
        else { return nil }
        
        return BarcodeDTO(date: date,
                          id: id,
                          title: title,
                          barcode: barcode,
                          strUrl: strUrl)
    }
    
    public var date: Date
    public var id: String
    public var title: String
    public var barcode: String
    public var strUrl: String
    
    public init(date: Date,
                id: String,
                title: String,
                barcode: String,
                strUrl: String) {
        self.date = date
        self.id = id
        self.title = title
        self.barcode = barcode
        self.strUrl = strUrl
    }
    
    public func createMO(context: NSManagedObjectContext) -> BarcodeMO? {
        let mo = BarcodeMO(context: context)
        mo.apply(dto: self)
        return mo
    }
    
}
