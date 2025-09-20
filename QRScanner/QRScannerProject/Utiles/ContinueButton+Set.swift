//
//  ContinueButton+Set.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension ContinueButton {
    
    @discardableResult
    func setIsEnable(_ value: Bool) -> ContinueButton {
        self.isEnable = value
        return self
    }
    
    @discardableResult
    func setArrowImageViewIsHidden(_ value: Bool) -> ContinueButton {
        self.arrowImageViewIsHidden = value
        return self
    }
    
    @discardableResult
    func startBounceAnimating() -> ContinueButton {
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
    func startActivityIndicatorAnimating() -> ContinueButton {
        self.activityIndicator.startAnimating()
        return self
    }
    
    @discardableResult
    func stopAnimating() -> ContinueButton {
        self.activityIndicator.stopAnimating()
        return self
    }
    
}

