//
//  AlertService+Scanner.swift
//  QRScanner
//
//  Created by George Popkich on 23.07.24.
//

import UIKit

struct ScannerAlertServiceUseCase: ScannerAlertServiceUseCaseProtocol {
    
    private let alertService: AlertService
    
    init(alertService: AlertService) {
        self.alertService = alertService
    }
    
    func showQRNoFoundAlert(title: String, okTitle: String) {
        alertService.showAlert(title: title, okTitle: okTitle)
    }
    
    func showCameraError(title: String,
                         message: String,
                         goSettings: String,
                         goSettingsHandler: @escaping () -> Void) {
        alertService.showAlert(title: title,
                               message: message, 
                               settingTitle: goSettings,
                               settingHandler: goSettingsHandler)
    }
    
    func showBarcodeInput(title: String,
                          actionTitle: String,
                          cancelTitle: String,
                          inputPlaceholder: String,
                          inputKeyboardType: UIKeyboardType,
                          actionHandler: @escaping (_ text: String?) -> Void) {
        alertService.showBarcodeInput(title: title,
                                      actionTitle: actionTitle,
                                      cancelTitle: cancelTitle,
                                      inputPlaceholder: inputPlaceholder,
                                      inputKeyboardType: inputKeyboardType,
                                      actionHandler: actionHandler)
    }
    
    func hideAlert() {
        alertService.hideAlert()
    }
    
}
