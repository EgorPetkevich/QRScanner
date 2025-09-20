//
//  MailAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 7.08.24.
//

import UIKit
import MessageUI

final class MailAssembler {
    
    private init() {}
    
    static func make(rootVC: UIViewController) -> MailVC? {
        if MFMailComposeViewController.canSendMail() {
            let mail = MailVC()
            mail.configureMailView(
                recipients: [Constants.Settings.mail],
                subject: "QR Code Reader - Scan Now",
                body: "Hello, I need assistance with your application.",
                from: rootVC
            )
            return mail
        }
        return nil
    }
}
