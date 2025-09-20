//
//  AlertService+Review.swift
//  QRScanner
//
//  Created by George Popkich on 8.08.24.
//

import Foundation

struct PaywallReviewAlertServiceUseCase: PaywallReviewAlertServiceUseCaseProtocol {
    
    let service: AlertService
    
    init(service: AlertService) {
        self.service = service
    }
    
    func showAlert(title: String, 
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void) {
        self.service.showAlert(title: title,
                       message: message,
                       cancelTitle: cancelTitle,
                       okTitle: okTitle,
                       okHandler: okHandler)
    }
    
}
