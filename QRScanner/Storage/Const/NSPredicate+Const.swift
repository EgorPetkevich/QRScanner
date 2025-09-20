//
//  NSPredicate+Const.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import CoreData

public extension NSPredicate {
    
    enum QRCode {
        public static func qrCode(byId id: String) -> NSPredicate {
            let idKeyPath = #keyPath(BaseQrCodeMO.identifier)
            return .init(format: "\(idKeyPath) CONTAINS[cd] %@", id)
        }
        
        public static func qrCodes(in ids: [String]) -> NSPredicate {
            let idKeyPath = #keyPath(BaseQrCodeMO.identifier)
            return NSCompoundPredicate(
                andPredicateWithSubpredicates:
                    [.init(format: "\(idKeyPath) IN %@", ids)])
        }
    }
    
}
