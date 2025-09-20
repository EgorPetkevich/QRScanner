//
//  BarcodeStorage.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import CoreData

public final class BarcodeStorage: QrCodeStorage<BarcodeDTO> {
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [BarcodeDTO] {
        return super.fetch(predicate: predicate,
                           sortDescriptors: sortDescriptors
        ).compactMap { $0 as? BarcodeDTO }
    }
    
}
