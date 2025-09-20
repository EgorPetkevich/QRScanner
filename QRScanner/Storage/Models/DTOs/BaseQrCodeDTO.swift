//
//  BaseQrCodeDTO.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import CoreData

public struct BaseQrCodeDTO: DTODescription {
    
    public typealias MO = BaseQrCodeMO
    
    public static func fromMO(_ mo: BaseQrCodeMO) -> BaseQrCodeDTO? {
        guard
            let id = mo.identifier,
            let date = mo.date,
            let title = mo.title
        else { return nil }
        
        return BaseQrCodeDTO(date: date, identifier: id, title: title)
    }
    
    public var date: Date
    public var id: String
    public var title: String
    
    public init(date: Date,
                identifier: String,
                title: String) {
        self.date = date
        self.id = identifier
        self.title = title
    }
    
    public func createMO(context: NSManagedObjectContext) -> BaseQrCodeMO? {
        let mo = BaseQrCodeMO(context: context)
        mo.apply(dto: self)
        return mo
    }
    
 
    
}
