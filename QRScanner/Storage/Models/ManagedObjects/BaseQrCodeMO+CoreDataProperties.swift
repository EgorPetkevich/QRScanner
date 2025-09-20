//
//  BaseQrCodeMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData


extension BaseQrCodeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseQrCodeMO> {
        return NSFetchRequest<BaseQrCodeMO>(entityName: "BaseQrCodeMO")
    }

    @NSManaged public var date: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var title: String?

}

extension BaseQrCodeMO : Identifiable {

}
