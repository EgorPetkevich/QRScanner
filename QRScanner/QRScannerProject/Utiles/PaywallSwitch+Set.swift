//
//  PaywallSwitch+Set.swift
//  QRScanner
//
//  Created by George Popkich on 18.07.24.
//

import Foundation

extension PaywallSwitch {
    
    @discardableResult
    func isOn(_ value: Bool) -> PaywallSwitch {
        self.isOn = value
        return self
    }
    
}
