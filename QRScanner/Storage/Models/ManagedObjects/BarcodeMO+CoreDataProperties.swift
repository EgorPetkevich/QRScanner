//
//  BarcodeMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData


extension BarcodeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BarcodeMO> {
        return NSFetchRequest<BarcodeMO>(entityName: "BarcodeMO")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var strUrl: String?

}
