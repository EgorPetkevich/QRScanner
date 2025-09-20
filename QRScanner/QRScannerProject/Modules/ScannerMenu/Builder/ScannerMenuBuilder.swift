//
//  ScannerMenuBuilder.swift
//  QRScanner
//
//  Created by George Popkich on 29.07.24.
//

import UIKit

final class ScannerMenuBuilder {
    
    private init() {}
    
    static func build(delegate: ScannerMenuDelegate,
                              sourceView: UIView) -> UIViewController {
        let adapter = ScannerMenuAdapter(actions: [.gallery, .barcode])
        let menu = ScannerMenuVC(adapter: adapter,
                                 delegate: delegate,
                                 sourceView: sourceView)
        menu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        return menu
    }
    
}
