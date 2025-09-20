//
//  QrCodeStorage+History.swift
//  QRScanner
//
//  Created by George Popkich on 3.08.24.
//

import Foundation
import Storage

struct HistoryQrCodeStorageUseCase: HistoryQrCodeStorageUseCaseProtocol {
    
    private let storage: AllQrCodeStorage
    
    init(storage: AllQrCodeStorage) {
        self.storage = storage
    }
    
    func deleteSelected(dtos: [any DTODescription]) {
        storage.deleteSelected(dtos: dtos)
    }
    
}
