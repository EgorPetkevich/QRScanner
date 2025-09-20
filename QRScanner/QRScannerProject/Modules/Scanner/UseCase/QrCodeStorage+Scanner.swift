//
//  QrCodeStorage+Scanner.swift
//  QRScanner
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import Storage

struct ScannerQrCodeStorageUseCase: ScannerQrCodeStorageUseCaseProtocol {
    
    private let storage: AllQrCodeStorage
    
    init(storage: AllQrCodeStorage) {
        self.storage = storage
    }
    
    func create(dto: any DTODescription, complition: @escaping (Bool) -> Void) {
        self.storage.create(dto: dto, complition: complition)
    }
    
}
