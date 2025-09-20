//
//  CopiedPopoverBuilder.swift
//  QRScanner
//
//  Created by George Popkich on 13.08.24.
//

import UIKit

final class CopiedPopoverBuilder {
    
    private init() {}
    
    static func buildCopiedVC(sourseView: UIView) -> UIViewController {
        let vc =  CopiedVC(sourseView: sourseView)
        vc.popoverPresentationController?.permittedArrowDirections = .down
        return vc
    }
    
}
