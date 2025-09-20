//
//  ScannerMenuCell.swift
//  QRScanner
//
//  Created by George Popkich on 29.07.24.
//

import UIKit

protocol ScannerMenuItem {
    var title: String { get }
    var icon: UIImage { get }
}

final class ScannerMenuCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .appWhite
       
        label.font = .appRegularFont(17.0)
        return label
    }()
    
    private lazy var iconView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(_ item: ScannerMenuItem) {
        titleLabel.text = item.title
        iconView.image = item.icon
        
    }
    
    func setupUI() {
        self.backgroundColor = .appBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconView)
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16.0)
        }
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(20.0)
            make.right.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
        }
    }
    
}
