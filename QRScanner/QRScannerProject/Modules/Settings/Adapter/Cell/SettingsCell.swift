//
//  SettingsCell.swift
//  QRScanner
//
//  Created by George Popkich on 4.08.24.
//

import UIKit

protocol SettingsItem {
    var title: String { get }
    var icon: UIImage { get }
}

final class SettingsCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .appWhite
        return label
    }()
    
    private lazy var iconImage: UIImageView = UIImageView()
    private lazy var arrowImageView = UIImageView(image: .Settings.arrowImage)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupSelectedBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(_ item: SettingsItem) {
        titleLabel.text = item.title
        iconImage.image = item.icon
    }
    
    func setupUI() {
        contentView.backgroundColor = .appDark
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(arrowImageView)
    }
    
    private func setupSelectedBackgroundView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .whiteSelected
        selectedBackgroundView = bgColorView
        
        selectedBackgroundView?.layer.masksToBounds = true
        selectedBackgroundView?.layer.zPosition =
        CGFloat(Float.greatestFiniteMagnitude)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedBackgroundView?.center.y = contentView.center.y
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(24.0)
            make.width.equalTo(150)
            make.left.equalTo(iconImage.snp.right).offset(8.0)
        }
        
        iconImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
            make.left.equalToSuperview().inset(16.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16.0, height: 16.0))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16.0)
        }
    }
    
    
}
