//
//  TextCell.swift
//  QRScanner
//
//  Created by George Popkich on 2.08.24.
//

import UIKit
import Storage
import SnapKit

final class TextCell: UITableViewCell {
    
    private lazy var content: UIView = .resultProductView()
    
    private lazy var titleLabel: UILabel = .titleCellLabel()
    private lazy var dateLabel: UILabel = .dateLabelCell()
    
    private lazy var arrowImageView = UIImageView(image: .Cell.arrowRightImage)
    private lazy var typeImageView: UIImageView = UIImageView()
    private lazy var checkMark: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupSelectedBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ dto: TextQrCodeDTO) {
        typeImageView.image = .Result.textImage
        titleLabel.text = dto.text
        dateLabel.text = get(date: dto.date)
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(content)
        
        content.addSubview(titleLabel)
        content.addSubview(dateLabel)
        content.addSubview(typeImageView)
        content.addSubview(arrowImageView)
        content.addSubview(checkMark)
    }
    
    private func setupSelectedBackgroundView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .whiteSelected
        selectedBackgroundView = bgColorView
        
        selectedBackgroundView?.layer.cornerRadius = 16.0
        selectedBackgroundView?.layer.masksToBounds = true
        selectedBackgroundView?.layer.zPosition =
        CGFloat(Float.greatestFiniteMagnitude)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedBackgroundView?.frame = (
            selectedBackgroundView?.frame.insetBy(dx: 0, dy: 8))!
        selectedBackgroundView?.center.y = contentView.center.y
    }
    
    private func setupConstraints() {
        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(68.0 + 16.0)
        }
        
        content.snp.makeConstraints { make in
            make.height.equalTo(68.0)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        content.cornerRadius = 16.0
        
        typeImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30.0, height: 30.0))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(typeImageView.snp.right).offset(8.0)
            make.top.equalToSuperview().inset(12.0)
            make.right.equalTo(arrowImageView.snp.left).inset(-11.0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(typeImageView.snp.right).offset(8.0)
            make.top.equalTo(titleLabel.snp.bottom).offset(2.0)
            make.bottom.equalToSuperview().inset(12.0)
            make.right.equalTo(arrowImageView.snp.left).inset(-11.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24.0, height: 24.0))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(7.0)
        }
        
        checkMark.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12.0)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(false, animated: animated)
        if editing {
            checkMark.isHidden = false
            typeImageView.snp.updateConstraints { make in
                make.left.equalToSuperview().inset(56.0)
            }
        } else {
            checkMark.isHidden = true
            typeImageView.snp.updateConstraints { make in
                make.left.equalToSuperview().inset(12.0)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            checkMark.image = .Cell.selectIconImage
        } else {
            checkMark.image = .Cell.unselectIconImage
        }
    }
    
    private func get(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
    
}
