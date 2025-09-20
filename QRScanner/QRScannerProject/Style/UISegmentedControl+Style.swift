//
//  UISegmentedControl+Style.swift
//  QRScanner
//
//  Created by George Popkich on 31.07.24.
//

import UIKit

extension UISegmentedControl {
    
    static func segmentedControl(items: [String]) -> UISegmentedControl {
        let items = items
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .segmentBackgroundColor
        return segmentedControl
    }
    
}

enum Segments: CaseIterable {
    case qrCode
    case barcode
    
    var conten: String {
        switch self {
        case .qrCode:
            return "qrCode"
        case .barcode:
            return "barcode"
        }
    }
}
