//
//  PhoneQrCodeMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData


extension PhoneQrCodeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneQrCodeMO> {
        return NSFetchRequest<PhoneQrCodeMO>(entityName: "PhoneQrCodeMO")
    }

    @NSManaged public var phone: String?

}
