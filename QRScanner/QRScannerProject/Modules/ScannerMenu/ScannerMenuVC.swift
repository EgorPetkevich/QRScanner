//
//  ScannerMenuVC.swift
//  QRScanner
//
//  Created by George Popkich on 29.07.24.
//

import UIKit
import SnapKit

protocol ScannerMenuAdapterProtocol {
    var tableView: UITableView { get }
    var contentHeight: CGFloat { get }
    var didSelectAction: ((ScannerMenuVC.Action) -> Void)? { get set }
}

protocol ScannerMenuDelegate: AnyObject {
    func didSelect(action: ScannerMenuVC.Action)
}

final class ScannerMenuVC: UIViewController {
    
    private enum Const {
        static let contentWidth: CGFloat = 250.0
    }
    
    enum Action: ScannerMenuItem {
        case gallery
        case barcode
        
        var title: String {
            switch self {
            case .gallery: return "Select from the gallery"
            case .barcode: return "Set barcode"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .gallery: return .ScannerMenu.galleryImage
            case .barcode: return .ScannerMenu.barcodeImage
            }
        }
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .popover }
        set {}
    }
    
    private var adapter: ScannerMenuAdapterProtocol
    
    private lazy var tableView: UITableView = adapter.tableView
    
    private weak var delegate: ScannerMenuDelegate?
    
    init(adapter: ScannerMenuAdapterProtocol, 
         delegate: ScannerMenuDelegate,
         sourceView: UIView) {
        self.adapter = adapter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        setupPopover(sourceView: sourceView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
        setupConstrains()
    }
    
    private func bind() {
        adapter.didSelectAction = { [weak self] action in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.delegate?.didSelect(action: action)
            })
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        view.addSubview(tableView)
    }
    
    private func setupConstrains() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(
                self.view.safeAreaLayoutGuide.snp.verticalEdges)

        }
    }
    
    private func setupPopover(sourceView: UIView) {
        preferredContentSize = CGSize(width: Const.contentWidth,
                                      height: adapter.contentHeight)
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceRect = CGRect(x: .zero,
                                                              y: sourceView.bounds.maxY + 68 ,
                                                              width: .zero,
                                                              height: .zero)
    }
    
}

extension ScannerMenuVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        return .none
    }
    
}

