//
//  TextQrCodeStorage.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import CoreData

public final class TextQrCodeStorage: QrCodeStorage<TextQrCodeDTO> {
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [TextQrCodeDTO] {
        return super.fetch(predicate: predicate,
                           sortDescriptors: sortDescriptors
        ).compactMap { $0 as? TextQrCodeDTO }
    }
    
}
