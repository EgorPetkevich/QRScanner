//
//  UIButton+Style.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UIButton {
    
    static func continueButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.appWhite, for: .normal)
        button.titleLabel?.font = .appRegularFont(16.0)
        button.backgroundColor = .clear

        return button
    }
    
    static func actionButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.appWhite, for: .normal)
        button.setTitleColor(.segmentBackgroundColor, for: .highlighted)
        button.titleLabel?.font = .appBoldFont(16.0)
        button.backgroundColor = .appButtonBlue
        
        return button
    }
    
    static func clearButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }
    
    static func scanButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .appButtonBlue
        button.setImage(.TabBar.scanImage, for: .normal)
        return button
    }
    
    static func lightButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .appBackground
        button.setImage(.Scanner.lightOffImage, for: .normal)
        return button
    }
    
    static func menuButton() -> UIButton {
        let button = UIButton()
        button.setImage(.Scanner.menuBurgerImage, for: .normal)
        return button
    }
    
    static func arrowButton() -> UIButton {
        let button = UIButton()
        button.setImage(.Result.arrowLeftImage, for: .normal)
        button.setTitleColor(.appWhite, for: .normal)
        button.backgroundColor = .clear
        return button
    }
    
    static func menuResultButton() -> UIButton {
        let button = UIButton()
        button.setImage(.Result.menuImage, for: .normal)
        return button
    }
    
    static func selectButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Select", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }
    
    static func deleteButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
        button.setTitleColor(.appRed, for: .normal)
        return button
    }
    
    static func exportButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Export", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
        button.setTitleColor(.appBlue, for: .normal)
        return button
    }
    
    static func crossButton() -> UIButton {
        let button = UIButton()
        button.setImage(.Onbording.cross, for: .normal)
        return button
    }
    
    static func underContinueButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.appRestorePrivacy, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.backgroundColor = .clear
        return button
    }
    
}

