//
//  PhoneResultVC.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import SnapKit

protocol PhoneResultViewModelProtocol {
    func getText() -> String
    func getQRImage() -> UIImage
    func arrowButtonDidTap()
    func copyButtonDidTap(sender: UIView)
    func actionButtonDidTap()
    func menuButtonDidTap()
}

final class PhoneResultVC: UIViewController {
    
    private lazy var titleLabel: UILabel = .resultTitleLabel()
    private lazy var qrImageView: UIImageView =
    UIImageView(image: viewModel.getQRImage())
    private lazy var typeView: UIView =
    ResultTypeView(image: .Result.phoneImage, text: "Phone")
    private lazy var resultView: InfoResultView =
    InfoResultView(self,
                   image: .Result.phoneImage,
                   text: viewModel.getText(),
                   action: #selector(copyButtonDidTap))
    
    private lazy var actionButton: UIButton =
        .actionButton(title: "Call")
        .addAction(self, action: #selector(actionButtonDidTap))
    private lazy var arrowButton: UIButton =
        .arrowButton()
        .addAction(self, action: #selector(arrowButtonDidTap))
    private lazy var menuButton: UIButton =
        .menuResultButton()
        .addAction(self, action: #selector(menuButtonDidTap))
    
    private var viewModel: PhoneResultViewModelProtocol
    
    init(viewModel: PhoneResultViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstrains()
    }
    
    private func bind() {
        
    }
    
    private func setup() {
        view.backgroundColor = .appBackground
        view.addSubview(titleLabel)
        view.addSubview(qrImageView)
        view.addSubview(typeView)
        view.addSubview(resultView)
        view.addSubview(actionButton)
        view.addSubview(arrowButton)
        view.addSubview(menuButton)
        
    }
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        qrImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(32.0)
            make.size.equalTo(CGSize(width: 167.0, height: 167.0))
        }
        qrImageView.layer.masksToBounds = true
        qrImageView.cornerRadius = 12.0
      
        typeView.snp.makeConstraints { make in
            make.top.equalTo(qrImageView.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(54.0)
        }
        typeView.cornerRadius = 12.0
        
        resultView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom).offset(32.0)
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
            make.height.equalTo(66.0)
        }
        resultView.cornerRadius = 16
        
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(64.0)
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(55.0)
        }
        actionButton.cornerRadius = 32.0
        
        arrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().inset(75.0)
            make.size.equalTo(CGSize(width: 24.0, height: 24.0))
        }
        
        menuButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().inset(74.0)
            make.size.equalTo(CGSize(width: 24.0, height: 24.0))
        }
        
    }
    
    @objc private func copyButtonDidTap() {
        viewModel.copyButtonDidTap(sender: resultView.buttonSoureView)
    }
    
    @objc private func actionButtonDidTap() {
        DispatchQueue.main.async { [weak self] in
            UIButton.animate(withDuration: 0.1,
                           animations: {
                self?.actionButton.transform = CGAffineTransform(scaleX: 0.95,
                                                                y: 0.95)
            }, completion: { _ in
                UIButton.animate(withDuration: 0.1) {
                    self?.actionButton.transform = CGAffineTransform.identity
                }
            })
        }
        
        viewModel.actionButtonDidTap()
    }
    
    @objc private func arrowButtonDidTap() {
        viewModel.arrowButtonDidTap()
    }
    
    @objc private func menuButtonDidTap() {
        viewModel.menuButtonDidTap()
    }
    
}
