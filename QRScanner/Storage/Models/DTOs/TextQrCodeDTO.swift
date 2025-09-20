//
//  TextQrCodeDTO.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import CoreData

public struct TextQrCodeDTO: DTODescription {
    
    public typealias MO = TextQrCodeMO
    
    public static func fromMO(_ mo: TextQrCodeMO) -> TextQrCodeDTO? {
        guard
            let id = mo.identifier,
            let title = mo.title,
            let date = mo.date,
            let text = mo.text
        else { return nil }
        
        return TextQrCodeDTO(date: date,
                             id: id,
                             title: title,
                             strUrl: mo.strUrl,
                             text: text)
    }
    
    public var date: Date
    public var id: String
    public var title: String
    public var strUrl: String?
    public var text: String
    
    public init(date: Date,
                id: String,
                title: String,
                strUrl: String? = nil,
                text: String) {
        self.date = date
        self.id = id
        self.title = title
        self.strUrl = strUrl
        self.text = text
    }
    
    public func createMO(context: NSManagedObjectContext) -> TextQrCodeMO? {
        let mo = TextQrCodeMO(context: context)
        mo.apply(dto: self)
        return mo
    }
    
}
