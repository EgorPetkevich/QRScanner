//
//  UrlQrCodeDTO.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import CoreData

public struct UrlQrCodeDTO: DTODescription {
    
    public typealias MO = UrlQrCodeMO
    
    static public func fromMO(_ mo: UrlQrCodeMO) -> UrlQrCodeDTO? {
        guard
            let id = mo.identifier,
            let date = mo.date,
            let title = mo.title,
            let strUrl = mo.strUrl
        else { return nil }
        
        return UrlQrCodeDTO(date: date, id: id, title: title, strUrl: strUrl)
    }
    
    public var date: Date
    public var id: String
    public var title: String
    public var strUrl: String
    
    public init(date: Date,
                id: String,
                title: String,
                strUrl: String) {
        self.date = date
        self.id = id
        self.title = title
        self.strUrl = strUrl
    }
    
    public func createMO(context: NSManagedObjectContext) -> UrlQrCodeMO? {
        let mo = UrlQrCodeMO(context: context)
        mo.apply(dto: self)
        return mo
    }
    
}
