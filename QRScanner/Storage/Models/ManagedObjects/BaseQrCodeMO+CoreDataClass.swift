//
//  BaseQrCodeMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData

@objc(BaseQrCodeMO)
public class BaseQrCodeMO: NSManagedObject, MODescription {

    public func toDTO() -> (any DTODescription)? {
        return BaseQrCodeDTO.fromMO(self)
    }
    
    public func apply(dto: any DTODescription) {
        self.identifier = dto.id
        self.date = dto.date
        self.title = dto.title
    }
    
}
