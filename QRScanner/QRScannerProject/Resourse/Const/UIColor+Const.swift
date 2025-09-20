//
//  UIColor+Const.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UIColor {
    
    convenience init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: CGFloat){
        self.init(red: CGFloat(r) / 256.0,
                  green: CGFloat(g) / 256.0,
                  blue: CGFloat(b) / 256.0,
                  alpha: CGFloat(a))
    }
    
    static var appBackground: UIColor = .init(42, 42, 42, 1)
    static var appButtonBlue: UIColor = .init(35, 145, 255, 1)
    static var appTitleWhite: UIColor = .init(255, 255, 255, 1)
    static var appDark: UIColor = .init(76, 76, 76, 1)
    static var appSubTitleProductionWhite: UIColor = .init(255, 255, 255, 0.6)
    static var appRestorePrivacy: UIColor = .init(255, 255, 255, 0.6)
    static var appSubTitleReviewWhite: UIColor = .init(255, 255, 255, 1)
    static var appPaywallButtonSubTitle: UIColor = .init(255, 255, 255, 0.5)
    static var appBlack: UIColor = .init(42, 42, 42, 1)
    static var appWhite: UIColor = .init(255, 255, 255, 1)
    static var appGradientTop: UIColor = .init(42, 42, 42, 0)
    static var appGradientBottom: UIColor = .init(42, 42, 42, 1)
    static var appGrey: UIColor = .init(163, 163, 163, 1)
    static var appScanerBackground: UIColor = .init(0, 0, 0, 0.6)
    static var segmentBackgroundColor: UIColor = .init(255, 255, 255, 0.2)
    static var appRed: UIColor = .init(255, 59, 48, 1)
    static var appBlue: UIColor = .init(35, 145, 255, 1)
    static var whiteSelected: UIColor = .init(255, 255, 255, 0.5)
}
