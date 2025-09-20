//
//  InfoResultView.swift
//  QRScanner
//
//  Created by George Popkich on 25.07.24.
//

import UIKit
import SnapKit

final class InfoResultView: UIView {
    
    private lazy var imageView: UIImageView = UIImageView(image: image)
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.text = text
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .appRegularFont(18.0)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(.Result.copyImage, for: .normal)
        button.addAction(target, action: action)
        return button
    }()
    
    private var image: UIImage
    private var text: String
    private var target: Any?
    private var action: Selector
    
    var buttonSoureView: UIView {
        get { button }
    }
    
    init(_ target: Any? ,image: UIImage, text: String, action: Selector) {
        self.target = target
        self.image = image
        self.text = text
        self.action = action
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupUI()
        setupConstrains()
    }
    
    private func setupUI() {
        self.backgroundColor = .appDark
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(button)
    }
    
    private func setupConstrains() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12.0)
            make.size.equalTo(CGSize(width: 30.0, height: 30.0))
        }
        imageView.layer.masksToBounds = true
        imageView.cornerRadius = 7.0
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(8.0)
            make.right.equalToSuperview().inset(50.0)
            make.bottom.top.equalToSuperview().inset(12.0)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15.0)
        }
    }
    
}

