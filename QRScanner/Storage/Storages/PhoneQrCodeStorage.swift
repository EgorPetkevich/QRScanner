//
//  PhoneQrCodeStorage.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import CoreData

public final class PhoneQrCodeStorage: QrCodeStorage<PhoneQrCodeDTO> {
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [PhoneQrCodeDTO] {
        return super.fetch(predicate: predicate,
                           sortDescriptors: sortDescriptors
        ).compactMap { $0 as? PhoneQrCodeDTO }
    }
    
}
