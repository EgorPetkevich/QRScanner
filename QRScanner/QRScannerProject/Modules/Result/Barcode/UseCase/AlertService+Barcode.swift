//
//  AlertService+Barcode.swift
//  QRScanner
//
//  Created by George Popkich on 28.07.24.
//

import Foundation

struct BarcodeResultAlertServiceUseCase:
    BarcodeResultAlertServiceUseCaseProtocol {
    
    private var service: AlertService
    
    init(service: AlertService) {
        self.service = service
    }
    
    func showActionSheet(actionTitle: String,
                         actionHandler: @escaping () -> Void,
                         deleteTitle: String,
                         deleteHandler: @escaping () -> Void,
                         cancelTitle: String ) {
        service.showActionSheet(actionTitle: actionTitle,
                                actionHandler: actionHandler,
                                deleteTitle: deleteTitle,
                                deleteHandler: deleteHandler,
                                cancelTitle: cancelTitle)
    }
    
}
