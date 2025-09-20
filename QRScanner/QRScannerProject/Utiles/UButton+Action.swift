//
//  UButton+Action.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func addAction(_ target: Any?,
                   action: Selector,
                   for event: UIControl.Event = .touchUpInside) -> UIButton {
        self.addTarget(target, action: action, for: event)
        return self
    }
    
}
