//
//  PaywallButton+Set.swift
//  QRScanner
//
//  Created by George Popkich on 26.08.24.
//

import UIKit

extension PaywallButton {
    
    @discardableResult
    func setIsEnable(_ value: Bool) -> PaywallButton {
        self.isEnable = value
        return self
    }
    
    @discardableResult
    func setArrowImageViewIsHidden(_ value: Bool) -> PaywallButton {
        self.arrowImageViewIsHidden = value
        return self
    }
    
    @discardableResult
    func startBounceAnimating() -> PaywallButton {
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        })
        return self
    }
    
    @discardableResult
    func startActivityIndicatorAnimating() -> PaywallButton {
        self.activityIndicator.startAnimating()
        return self
    }
    
    @discardableResult
    func stopAnimating() -> PaywallButton {
        self.activityIndicator.stopAnimating()
        return self
    }
    
}

