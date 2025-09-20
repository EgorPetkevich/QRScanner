//
//  SegmentControl.swift
//  QRScanner
//
//  Created by George Popkich on 31.07.24.
//

import UIKit
import AVFoundation

final class SegmentControl: UISegmentedControl {
    
    lazy var radius = self.bounds.height / 2
    
    
      
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .segmentBackgroundColor
        self.cornerRadius = radius
        self.layer.masksToBounds = true
       
        let selectedFont = UIFont.systemFont(ofSize: 15, weight:  .bold)
        
        let normalFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        self.setTitleTextAttributes([NSAttributedString.Key.font : selectedFont,
                                     NSAttributedString.Key.foregroundColor: UIColor.appBackground],
                                    for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.font: normalFont,
                                     NSAttributedString.Key.foregroundColor: UIColor.appWhite,
                                     NSAttributedString.Key.backgroundColor: UIColor.clear.cgColor],
                                    for: .normal)
        self.tintColor = UIColor.segmentBackgroundColor
        let selectedImageViewIndex = numberOfSegments
        subviews.forEach{$0.bounds = $0.bounds.insetBy(dx: 6.0, dy: 6.0)}

        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedImageView.backgroundColor = .appWhite
            selectedImageView.image = nil
            selectedImageView.cornerRadius = selectedImageView.bounds.height / 2
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SegmentControl {
    
    @discardableResult
    func addAction(_ target: Any?,
                   action: Selector,
                   for event: UIControl.Event = .valueChanged) -> SegmentControl {
        self.addTarget(target, action: action, for: event)
        return self
    }
    
}
