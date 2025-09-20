//
//  SettingsVC.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import MessageUI

protocol SettingsViewModelProtocol {
    func makeTableView() -> UITableView
}

final class SettingsVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    private lazy var titleLabel: UILabel = .mainTitleLabel("Settings")
    private lazy var settingView: UIView = .contentView()
    private lazy var tableView: UIView = viewModel.makeTableView()
    
    private var viewModel: SettingsViewModelProtocol
    
    private lazy var scanerItemView: UIView = {
        let view = UIView()
        view.backgroundColor = .appButtonBlue
        return view
    }()
    
    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(title: "Settings", 
                                       image: .TabBar.settingsImage, tag: .zero)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -10.0,
                                                      vertical: -10.0)
        let attributes = [NSAttributedString.Key.font: UIFont.appBoldFont(15)]
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        view.addSubview(titleLabel)
        view.addSubview(settingView)
        settingView.addSubview(tableView)
    }
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(33.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(settingView.snp.top).inset(-8.0)
        }
        
        settingView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(111.0)
            make.bottom.equalToSuperview().inset(101.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.height.equalTo(319.0)
        }
    }
    
}
