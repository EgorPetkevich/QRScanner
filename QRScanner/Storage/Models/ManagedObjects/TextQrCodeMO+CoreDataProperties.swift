//
//  TextQrCodeMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData


extension TextQrCodeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextQrCodeMO> {
        return NSFetchRequest<TextQrCodeMO>(entityName: "TextQrCodeMO")
    }

    @NSManaged public var text: String?
    @NSManaged public var strUrl: String?

}
