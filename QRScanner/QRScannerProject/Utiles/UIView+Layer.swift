//
//  UIView+Layer.swift
//  QRScanner
//
//  Created by George Popkich on 18.07.24.
//

import UIKit
extension UIView {
    
    var shadowColor: CGColor {
        get { layer.shadowColor! }
        set { layer.shadowColor = newValue }
    }
    
    var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func bounceAnimation(duration: TimeInterval = 1.0,
                        fromValue: CGFloat = 1.0,
                        toValue: CGFloat = 1.05) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = fromValue
        pulseAnimation.toValue = toValue
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        
        self.layer.add(pulseAnimation, forKey: "bounce")
    }
    
}
