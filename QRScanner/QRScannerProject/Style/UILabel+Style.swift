//
//  UILabel+Style.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

extension UILabel {
    
    static func title(_ text: String) -> UILabel {
        let label = UILabel()
        let text = text
        label.attributedText = .parse(html: text,
                                      font: .appTitleFont,
                                      fontWeight: 900.0)
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.textColor = .appTitleWhite
        return label
    }
    
    static func productionSubtitle(_ text: String) -> UILabel {
        let text = text
        let label = UILabel()
        label.attributedText = .parse(html: text,
                                      font: .appSubTitleFont,
                                      fontWeight: 400.0)
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.textColor = .appSubTitleProductionWhite
        
        return label
    }
    
    static func paywallProdSubtitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .appSubTitleProductionWhite
        
        return label
    }
    
    static func reviewSubtitle(_ text: String) -> UILabel {
        let text = text
        let label = UILabel()
        label.attributedText = .parse(html: text,
                                      font: .appSubTitleFont,
                                      fontWeight: 400.0)
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.textColor = .appSubTitleReviewWhite
        
        return label
    }
    
    static func paywallRevSubtitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .appSubTitleReviewWhite
        
        return label
    }
    
    static func restorePrivacy(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .appRestorePrivacy
        label.font = .appRegularFont(14)
        return label
    }
    
    static func lightLabel() -> UILabel {
        let label = UILabel()
        label.text = "Light"
        label.textColor = .appWhite
        label.textAlignment = .center
        label.font = .appRegularFont(15.0)
        return label
    }
    
    static func mainTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.attributedText = .parse(html: text,
                                      font: .systemFont(ofSize: 28),
                                      fontWeight: 700.0)
        label.textColor = .appWhite
        return label
    }
    
    static func scanerInfoLabel() -> UILabel {
        let label = UILabel()
        label.text = "Align the QR code inside the frame to scan."
        label.font = .appRegularFont(15.0)
        label.textColor = .appWhite
        label.textAlignment = .center
        return label
    }
    
    static func resultTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Result"
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 28,
                                 weight: UIFont.Weight(rawValue: 700))
        return label
    }
    
    static func resultProductLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .appWhite
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .appBoldFont(20.0)
        return label
    }
    
    static func noHistoryLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = .parse(html: text,
                                      font: .systemFont(ofSize: 20.0),
                                      fontWeight: 700)
        label.textColor = .appWhite
        return label
    }
    
    static func historyInfoLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = .parse(html: text,
                                      font: .systemFont(ofSize: 15.0),
                                      fontWeight: 400)
        label.textColor = .appGrey
        return label
    }
    
    static func titleCellLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        return label
    }
    
    static func dateLabelCell() -> UILabel {
        let label = UILabel()
        label.textColor = .appGrey
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        return label
    }
    
}
