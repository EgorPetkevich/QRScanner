//
//  PhoneQrCodeDTO.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import CoreData

public struct PhoneQrCodeDTO: DTODescription {
    
    public typealias MO = PhoneQrCodeMO
    
    static public func fromMO(_ mo: PhoneQrCodeMO) -> PhoneQrCodeDTO? {
        guard 
            let id = mo.identifier,
            let date = mo.date,
            let title = mo.title,
            let phone = mo.phone
        else { return nil }
        
        return PhoneQrCodeDTO(date: date, id: id, title: title, phone: phone)
    }
    
    public var date: Date
    public var id: String
    public var title: String
    public var phone: String
    
    public init(date: Date, id: String, title: String, phone: String) {
        self.date = date
        self.id = id
        self.title = title
        self.phone = phone
    }
    
    public func createMO(context: NSManagedObjectContext) -> PhoneQrCodeMO? {
        let mo = PhoneQrCodeMO(context: context)
        mo.apply(dto: self)
        return mo
    }
    
    
}

