//
//  HistoryVC.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import SnapKit

protocol HistoryViewModelProtocol {
    var buttonTitleState: ((String) -> Void)? { get set }
    var buttonState: ((HistoryVM.ButtonTitleState) -> Void)? { get set }
    var showActionView: ((Bool) -> Void)? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func segmentControlDidChange(value: Int)
    func makeTableView() -> UITableView
    func scanCodeButtonDidTap()
    func selectButtonDidTap()
    func deleteButtonDidTap()
    func exportButtonDidTap()
}

final class HistoryVC: UIViewController {
    
    enum Const {
        static var segmentedControl: CGFloat = 43.0
        static var scanCodeButtonHeight: CGFloat = 64.0
    }
    
    private var isSelect = false
    
    private lazy var tableView: UITableView = viewModel.makeTableView()
    private lazy var headerView: UIView = .contentView()
    
    private lazy var titleLabel: UILabel = .mainTitleLabel("History")
    private lazy var segmentedControl: UISegmentedControl = 
    SegmentControl(items: ["QR code", "Barcode"])
        .addAction(self, action: #selector(segmentDidChange(_:)))
                   
    private lazy var actionView: UIView = .contentView()
    private lazy var noHistoryLabel: UILabel = 
        .noHistoryLabel(text: "No Scan History")
    private lazy var infoLabel: UILabel =
        .historyInfoLabel(text: "You haven't scanned any QR codes<br>yet. Start scanning")
    
    private lazy var selectButton: UIButton =
        .selectButton()
        .addAction(self, action: #selector(selectButtonDidTap(_:)))
    private lazy var scanCodeButton: UIButton =
        .actionButton(title: "Scan code")
        .addAction(self, action: #selector(scanCodeButtonDidTap))
    
    private lazy var editView: UIView = .contentView()
    private lazy var deleteButton: UIButton = 
        .deleteButton()
        .addAction(self, action: #selector(deleteButtonDidTap))
    
    private lazy var exportButton: UIButton =
        .exportButton()
        .addAction(self, action: #selector(exportButtonDidTap))
    
    private var viewModel: HistoryViewModelProtocol
    
    init(viewModel: HistoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func bind() {
        viewModel.buttonTitleState = { [weak self] title in
            self?.selectButton.setTitle(title, for: .normal)
        }
        viewModel.buttonState = { [weak self] state in
            switch state {
            case .select:
                self?.editView.isHidden = true
            case .cancel:
                self?.editView.isHidden = false
            }
        }
        viewModel.showActionView = { [weak self] showActionView in
            if showActionView {
                self?.actionView.isHidden = false
                self?.tableView.isHidden = true
                self?.selectButton.isHidden = true
            } else {
                self?.actionView.isHidden = true
                self?.tableView.isHidden = false
                self?.selectButton.isHidden = false
            }
        }
    }
    
    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(title: "History",
                                       image: .TabBar.historyImage, tag: .zero)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 10,
                                                      vertical: -10.0)
        let attributes = [NSAttributedString.Key.font: UIFont.appBoldFont(15)]
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        tabBarController?.tabBar.addSubview(editView)
        view.addSubview(headerView)
        view.addSubview(actionView)
        view.addSubview(tableView)
        
        actionView.addSubview(noHistoryLabel)
        actionView.addSubview(infoLabel)
        actionView.addSubview(scanCodeButton)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(segmentedControl)
        headerView.addSubview(selectButton)
        
        editView.addSubview(exportButton)
        editView.addSubview(deleteButton)
        editView.isHidden = true
//        tableView.isHidden = true
    }
    
    private func setupConstrains() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70.0)
        }
        
        selectButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().inset(12.0)
        }

        segmentedControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.top.equalTo(titleLabel.snp.bottom).inset(-16.0)
            make.height.equalTo(Const.segmentedControl)
            make.bottom.equalToSuperview().inset(16.0)
        }
        
        actionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview().inset(110.0)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview().inset(110.0)
        }
        
        noHistoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(157)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noHistoryLabel.snp.bottom).inset(-18)
        }
        
        scanCodeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(Const.scanCodeButtonHeight)
            make.width.equalTo(229.0)
            make.top.equalTo(infoLabel.snp.bottom).inset(-26)
        }
        scanCodeButton.cornerRadius = Const.scanCodeButtonHeight / 2
        
        editView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        exportButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().inset(13.0)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.top.equalToSuperview().inset(13.0)
        }
        
    }
    
    @objc private func scanCodeButtonDidTap() {
        viewModel.scanCodeButtonDidTap()
    }
    
    @objc private func segmentDidChange(_ sender: UISegmentedControl) {
        viewModel.segmentControlDidChange(value: sender.selectedSegmentIndex)
    }
    
    @objc private func selectButtonDidTap(_ sender: UIButton) {
        viewModel.selectButtonDidTap()
    }
    
    @objc private func deleteButtonDidTap() {
        viewModel.deleteButtonDidTap()
    }
    
    @objc private func exportButtonDidTap() {
        viewModel.exportButtonDidTap()
    }
    
}
