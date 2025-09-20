//
//  QrCodeStorage+Text.swift
//  QRScanner
//
//  Created by George Popkich on 3.08.24.
//

import Foundation
import Storage

struct TextResultQrCodeStorageUseCase:
    TextResultQrCodeStorageUseCaseProtocol {
    
    private let storage: AllQrCodeStorage
    
    init(storage: AllQrCodeStorage) {
        self.storage = storage
    }
    
    func delete(dto: any DTODescription) {
        storage.delete(dto: dto)
    }
    
}
