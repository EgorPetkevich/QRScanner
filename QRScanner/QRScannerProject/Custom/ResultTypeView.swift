//
//  ResultType.swift
//  QRScanner
//
//  Created by George Popkich on 25.07.24.
//

import UIKit
import SnapKit

final class ResultTypeView: UIView {
    
    private lazy var imageView: UIImageView = UIImageView(image: image)
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = text
        label.textColor = .appWhite
        label.textAlignment = .center
        label.font = .appBoldFont(20.0)
        return label
    }()
    
    private var image: UIImage
    private var text: String
    
    init(image: UIImage, text: String) {
        self.image = image
        self.text = text
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
    }
    
    private func setupConstrains() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12.0)
            make.size.equalTo(CGSize(width: 30.0, height: 30.0))
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(15.0)
            make.right.equalToSuperview().inset(12.0)
        }
    }
    
}
