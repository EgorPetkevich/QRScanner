//
//  UrlQrCodeMO+CoreDataProperties.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData


extension UrlQrCodeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UrlQrCodeMO> {
        return NSFetchRequest<UrlQrCodeMO>(entityName: "UrlQrCodeMO")
    }

    @NSManaged public var strUrl: String?

}
