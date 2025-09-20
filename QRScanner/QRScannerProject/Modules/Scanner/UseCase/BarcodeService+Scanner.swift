//
//  BarcodeService+Scanner.swift
//  QRScanner
//
//  Created by George Popkich on 30.07.24.
//

import Foundation
import Storage

struct ScannerBarcodeServiceUseCase: ScannerBarcodeServiceUseCaseProtocol {
    
    private var service: BarcodeService
    
    init(service: BarcodeService) {
        self.service = service
    }
    
    func getBarcodeData(barcode: String,
                        completion: @escaping (any DTODescription) -> Void,
                        notFound: @escaping () -> Void) {
        service.getBarcodeData(barcode: barcode,
                               completion: completion,
                               notFound: notFound)
    }
    
}
