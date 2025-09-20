//
//  UIImage+Const.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UIImage {
    
    //MARK: Onboarding
    enum Onbording {
        static let buttonArrow: UIImage = .init(named: "arrowRight")!
        static let firstStepImage: UIImage = .init(named: "imageFirstStep")!
        static let secondStepImage: UIImage = .init(named: "imageSecondStep")!
        static let thirdStepImage: UIImage = .init(named: "imageThirdStep")!
        static let cross: UIImage = .init(named: "cross")!
    }
    
    //MARK: TabBar
    enum TabBar {
        static let scanImage: UIImage = .init(named: "scanner")!
        static let scanButton: UIImage = .init(named: "scannerButton")!
        static let historyImage: UIImage = .init(named: "history")!
        static let settingsImage: UIImage = .init(named: "settings")!
    }
    
    //MARK: Scaner
    enum Scanner {
        static let lightOnImage: UIImage = .init(named: "lightOn")!
        static let lightOffImage: UIImage = .init(named: "lightOff")!
        static let menuBurgerImage: UIImage = .init(named: "menuBurger")!
        static let frameImage: UIImage = .init(named: "frame")!
    }
    
    //MARK: Result
    enum Result {
        static let linkImage: UIImage = .init(named: "link")!
        static let phoneImage: UIImage = .init(named: "phone")!
        static let textImage: UIImage = .init(named: "text")!
        static let copyImage: UIImage = .init(named: "copyimage")!
        static let arrowLeftImage: UIImage = .init(named: "arrowleft")!
        static let menuImage: UIImage = .init(named: "dots")!
        static let stubImage: UIImage = .init(named: "stub")!
    }
    
    //MARK: ScannerMenu
    enum ScannerMenu {
        static let galleryImage: UIImage = .init(named: "gallery")!
        static let barcodeImage: UIImage = .init(named: "barcode")!
    }
    
    //MARK: Cell
    enum Cell {
        static let arrowRightImage: UIImage = .init(named: "arrowright")!
        static let selectIconImage: UIImage = .init(named: "select")!
        static let unselectIconImage: UIImage = .init(named: "unselect")!
    }
    
    //MARK: Settings
    enum Settings {
        static let cameraImage: UIImage = .init(named: "camera")!
        static let emailImage: UIImage = .init(named: "emailimage")!
        static let fileImage: UIImage = .init(named: "fileimage")!
        static let privacyImage: UIImage = .init(named: "shield")!
        static let shareImage: UIImage = .init(named: "share")!
        static let arrowImage: UIImage = .init(named: "arrowsetting")!
    }
    
    //MARK: Launch
    enum Launch {
        static let iconImage: UIImage = .init(named: "icon")!
    }
    
    //MARK: Shortcut
    enum Shortcut {
        static let trashImage: UIImage = .init(named: "trash")!
    }
    
}
