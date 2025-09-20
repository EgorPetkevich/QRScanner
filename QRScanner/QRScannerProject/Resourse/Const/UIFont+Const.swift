//
//  UIFont+Const.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UIFont {
    
    static var appTitleFont: UIFont =
        .systemFont(
            ofSize: 36.0,
            weight: UIFont.Weight(rawValue: 900)
        )
    
    static var appSubTitleFont: UIFont =
        .systemFont(
            ofSize: 16.0,
            weight: UIFont.Weight(rawValue: 400)
        )
    
    static var appButtonReviewFont: UIFont = .systemFont(ofSize: 16)
    
    static func appRegularFont (_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }
    
    static func appBoldFont (_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .bold)
    }
    
    static func appText(_ size: CGFloat, weight: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: UIFont.Weight(weight))
    }
      
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
      let newDescriptor = fontDescriptor.addingAttributes([.traits: [
        UIFontDescriptor.TraitKey.weight: weight]
      ])
      return UIFont(descriptor: newDescriptor, size: pointSize)
    }
    
}
