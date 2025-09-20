//
//  Mailoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 7.08.24.
//

import UIKit
import MessageUI

final class MailCoordinator: Coordinator {
    
    private var rootVC: UIViewController
    
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
    }
    
    override func start() -> MailVC? {
        if let vc = MailAssembler.make(rootVC: rootVC) {
            return vc
        }
        return nil
    }
    
}
