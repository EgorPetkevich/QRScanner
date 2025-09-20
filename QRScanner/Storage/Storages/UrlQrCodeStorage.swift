//
//  UrlQrCodeStorage.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import CoreData

public final class UrlQrCodeStorage: QrCodeStorage<UrlQrCodeDTO> {
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [UrlQrCodeDTO] {
        return super.fetch(predicate: predicate,
                           sortDescriptors: sortDescriptors
        ).compactMap { $0 as? UrlQrCodeDTO }
    }
    
}
