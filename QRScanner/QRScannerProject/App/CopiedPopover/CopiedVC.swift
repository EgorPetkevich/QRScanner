//
//  CopiedVC.swift
//  QRScanner
//
//  Created by George Popkich on 13.08.24.
//

import UIKit
import SnapKit

final class CopiedVC: UIViewController {

    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .popover } set {}
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "copied"
        label.backgroundColor = .clear
        label.textColor = .appWhite
        label.textAlignment = .center
        return label
    }()
    
    init(sourseView: UIView) {
        super.init(nibName: nil, bundle: nil)
        setupPopover(sourseView: sourseView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.dismiss(animated: true)
        }
        setupUI()
        setupConstrains()
    }
    
    private func setupUI() {
        view.backgroundColor = .appDark
        view.addSubview(label)
    }
    
    private func setupConstrains() {
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(
                self.view.safeAreaLayoutGuide.snp.verticalEdges)
        }
    }
    
    private func setupPopover(sourseView: UIView) {
        preferredContentSize = 
        CGSize(width: label.intrinsicContentSize.width + 20,
               height: label.intrinsicContentSize.height + 20)
        popoverPresentationController?.sourceView = sourseView
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceRect =
        CGRect(x: sourseView.bounds.midX,
               y: 0.0,
               width: .zero,
               height: .zero)
    }
    
}

extension CopiedVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        return .none
    }
    
}
