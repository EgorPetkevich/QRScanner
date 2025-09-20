//
//  BarcodeResultVC.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import SnapKit

protocol BarcodeResultViewModelProtocol {
    func getText() -> String
    func getQRImage() -> UIImage
    func getProductName() -> String
    func getStrUrl() -> String
    func arrowButtonDidTap()
    func copyBarcodeButtonDidTap(sender: UIView)
    func copyLinkButtonDidTap(sender: UIView)
    func actionButtonDidTap()
    func menuButtonDidTap()
}

final class BarcodeResultVC: UIViewController {
    
    private lazy var titleLabel: UILabel = .resultTitleLabel()
    private lazy var qrImageView: UIImageView =
    UIImageView(image: viewModel.getQRImage())
    private lazy var typeView: UIView = .resultProductView()
    private lazy var productNameLabel: UILabel = .
    resultProductLabel(text: viewModel.getProductName())
    private lazy var resultView: InfoResultView =
    InfoResultView(self,
                   image: viewModel.getQRImage(),
                   text: viewModel.getText(),
                   action: #selector(copyBarcodeButtonDidTap))
    private lazy var linkResultView: InfoResultView =
    InfoResultView(self,
                   image: .Result.linkImage,
                   text: viewModel.getStrUrl(),
                   action: #selector(copyLinkButtonDidTap))
    
    private lazy var actionButton: UIButton =
        .actionButton(title: "Open in browser")
        .addAction(self, action: #selector(actionButtonDidTap))
    private lazy var arrowButton: UIButton =
        .arrowButton()
        .addAction(self, action: #selector(arrowButtonDidTap))
    private lazy var menuButton: UIButton =
        .menuResultButton()
        .addAction(self, action: #selector(menuButtonDidTap))
    
    private var viewModel: BarcodeResultViewModelProtocol
    
    init(viewModel: BarcodeResultViewModelProtocol) {
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
        typeView.addSubview(productNameLabel)
        view.addSubview(typeView)
        view.addSubview(resultView)
        view.addSubview(linkResultView)
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
            make.trailing.leading.equalTo(qrImageView)
            make.centerX.equalToSuperview()
        }
        typeView.cornerRadius = 12.0
        
        productNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12.0)
            make.verticalEdges.equalToSuperview().inset(12.0)
        }
        
        resultView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom).offset(32.0)
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
        }
        resultView.cornerRadius = 16
        
        linkResultView.snp.makeConstraints { make in
            make.top.equalTo(resultView.snp.bottom).offset(16.0)
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
        }
        linkResultView.cornerRadius = 16
        
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
    
    @objc private func copyBarcodeButtonDidTap() {
        viewModel.copyBarcodeButtonDidTap(sender: resultView.buttonSoureView)
    }
    
    @objc private func copyLinkButtonDidTap() {
        viewModel.copyLinkButtonDidTap(sender: linkResultView.buttonSoureView)
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
