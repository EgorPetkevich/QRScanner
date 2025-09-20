//
//  UIView+Styles.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UIView {
    
    static func contentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .appBackground
        return view
    }
    
    static func gradientView() -> UIView {
        let gradientView = UIView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: UIScreen.main.bounds.width,
                                                height: 116.0))
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = gradientView.frame.size
        gradientLayer.colors =
        [UIColor.appGradientTop.cgColor ,UIColor.appGradientBottom.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        return gradientView
    }
    
    static func scanerViewBackground() -> UIView {
        let view = UIView()
        view.backgroundColor = .appScanerBackground
        return view
    }
    
    static func spinnerAnimationBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .appScanerBackground
        return view
    }
    
    static func resultProductView() -> UIView {
        let view = UIView()
        view.backgroundColor = .appDark
        return view
    }
    
}
