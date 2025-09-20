//
//  MainTabBarVC.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import SnapKit

@objc protocol MainTabBarViewModelProtocol {
    @objc func scanerButtonDidTap()
}

final class MainTabBarVC: UITabBarController {
    
    private enum Const {
        static let scanButtonSide: CGFloat = 64.0
    }
    
    private lazy var scanButton: UIButton = 
        .scanButton()
        .addAction(self, action: #selector(scanerButtonDidTap))
    
    private var viewModel: MainTabBarViewModelProtocol
    
    init(viewModel: MainTabBarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tabBar.itemPositioning = .fill
        self.tabBar.frame.size.height = 109
        self.tabBar.frame.origin.y = view.frame.height - 109
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    private func setupUI() {
        tabBar.tintColor = .appWhite
        tabBar.backgroundColor = .appBackground
        tabBar.unselectedItemTintColor = .appGrey
   
        tabBar.addSubview(scanButton)
    }
    
    private func setupConstrains() {
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8.0)
            make.size.equalTo(CGSize(width: Const.scanButtonSide,
                                     height: Const.scanButtonSide))
        }
        scanButton.cornerRadius =  Const.scanButtonSide / 2
        
    }

    @objc func scanerButtonDidTap() {
        viewModel.scanerButtonDidTap()
    }
    
}

