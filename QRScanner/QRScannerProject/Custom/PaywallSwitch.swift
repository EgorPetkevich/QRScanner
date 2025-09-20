//
//  PaywallSwitch.swift
//  QRScanner
//
//  Created by George Popkich on 18.07.24.
//

import UIKit
import SnapKit


final class PaywallSwitch: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "I want my Free Trial."
        label.font = .appRegularFont(15.0)
        label.textColor = .appBackground
        return label
    }()
    
    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(target, action: action, for: .valueChanged)
        return switchView
    }()
    
    private var target: Any?
    private var action: Selector
    
    init(target: Any?, action: Selector) {
        self.target = target
        self.action = action
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isOn: Bool {
        get { switchView.isOn }
        set { switchView.isOn = newValue}
    }
    
    private func commonInit() {
        setupUI()
        setupConstrains()
    }
    
    private func setupUI() {
        self.backgroundColor = .appWhite
        addSubview(titleLabel)
        addSubview(switchView)
    }
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.centerY.equalToSuperview()
        }
        
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(14.0)
            make.centerY.equalToSuperview()
        }
    }
    
}
