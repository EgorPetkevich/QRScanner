//
//  AlertService+Text.swift
//  QRScanner
//
//  Created by George Popkich on 26.07.24.
//

import Foundation

struct TextResultAlertServiceUseCase: TextResultAlertServiceUseCaseProtocol {
    
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
