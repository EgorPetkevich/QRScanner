//
//  QRCodeService+Scanner.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import Foundation
import Storage

struct QRCodeServiceUseCase: QRCodeServiceUseCaseProtocol {
    
    private var service: QRCodeService
    
    init(service: QRCodeService) {
        self.service = service
    }
    
    func getQRCodeData(_ str: String, 
                       complitionHandler: @escaping (any DTODescription) -> Void,
                       errorHandler: () -> Void) {
        self.service.getQRCodeData(str,
                                   complitionHandler: complitionHandler,
                                   errorHandler: errorHandler)
    }
    
}
