//
//  NSSortDescriptor+Const.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import CoreData

public extension NSSortDescriptor {
    
    enum QrCode {
        public static func qrCode(byID id: String) -> NSPredicate {
            let idKeypath = #keyPath(BaseQrCodeMO.identifier)
            return .init(format: "\(idKeypath) CONTAINS[cd] %@", id)
        }
        
        public static var byDate: NSSortDescriptor {
            let dateKeyPath = #keyPath(BaseQrCodeMO.date)
            return .init(key: dateKeyPath, ascending: false)
        }
    }
    
}
