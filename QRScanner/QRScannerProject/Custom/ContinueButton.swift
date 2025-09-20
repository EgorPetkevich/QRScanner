//
//  ContinueButton.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit
import SnapKit

final class ContinueButton: UIView {
    
    private enum Const {
        static var continueButtonHeight = 64.0
        static var contenCirculeSide = 48.0
    }
    
    lazy var button: UIButton = 
        .clearButton()
        .addAction(target, action: action)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.attributedText = .parse(html: titleText, font: .appSubTitleFont)
        label.textColor = .appSubTitleReviewWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var arrowImageView: UIView = {
        let view = UIImageView(image: .Onbording.buttonArrow)
        view.tintColor = .appWhite
        view.backgroundColor = .appBlack
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .appWhite
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var contentCircule: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack
        return view
    }()
    
    var target: Any?
    var action: Selector
    var titleText: String
    
    init(target: Any?,
         action: Selector,
         for event: UIControl.Event = .touchUpInside, 
         titleText: String) {
        self.target = target
        self.action = action
        self.titleText = titleText
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isEnable: Bool {
        get { button.isEnabled }
        set { button.isEnabled = newValue}
    }
    
    var arrowImageViewIsHidden: Bool {
        get { arrowImageView.isHidden }
        set { arrowImageView.isHidden = newValue }
    }
    
    func addAction(_ target: Any?,
                   action: Selector,
                   for event: UIControl.Event = .touchUpInside) {
        button.addTarget(target, action: action, for: event)
    }
    
    private func commonInit() {
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .appButtonBlue
        addSubview(titleLabel)
        addSubview(contentCircule)
        addSubview(button)
        contentCircule.addSubview(arrowImageView)
        contentCircule.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Const.continueButtonHeight)
        }
        self.cornerRadius = Const.continueButtonHeight / 2
        
        button.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        button.cornerRadius = self.cornerRadius
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        contentCircule.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: Const.contenCirculeSide,
                                     height: Const.contenCirculeSide))
            make.right.equalToSuperview().inset(8.0)
            make.centerY.equalToSuperview()
        }
        
        contentCircule.cornerRadius = Const.contenCirculeSide / 2
        arrowImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

