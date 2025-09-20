//
//  SettingsVM.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import MessageUI

protocol SettingsCoordinatorProtocol: AnyObject {
    func emailDidSelect()
    func shareApp(url: URL)
}

protocol SettingsAdapterProtocol {
    var cellDidSelect: ((SettingsSection.Settings) -> Void)? { get set }
    func makeTableView() -> UITableView
}

final class SettingsVM: NSObject, SettingsViewModelProtocol {
    
    weak var coordinator: SettingsCoordinatorProtocol?
    
    private var adapter: SettingsAdapterProtocol
    
    init(coordinator: SettingsCoordinatorProtocol,
         adapter: SettingsAdapterProtocol) {
        self.coordinator = coordinator
        self.adapter = adapter
        super.init()
        bind()
    }
    
    private func bind() {
        adapter.cellDidSelect = { [weak self] cell in
            switch cell {
            case .email:
                self?.emailDidSelect()
                return
            case .share:
                self?.shareDidSelect()
                return
            case .camera:
                self?.cameraDidSelect()
                return 
            case .terms: 
                self?.termsDidSelect()
                return
            case .privacy: 
                self?.privacyDidSelect()
                return
            }
        }
    }
    
    private func cameraDidSelect() {
        UIApplication.shared.open(
            URL(string: UIApplication.openSettingsURLString)!,
            options: [:], completionHandler: nil)
    }
    
    private func emailDidSelect() {
        coordinator?.emailDidSelect()
    }
    
    private func termsDidSelect() {
        if let url = URL(string:  Constants.Settings.terms) {
            UIApplication.shared.open(url)
        }
    }
    
    private func privacyDidSelect() {
        if let url = URL(string: Constants.Settings.privacy) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareDidSelect() {
        if let url = URL(string: Constants.Settings.share) {
            coordinator?.shareApp(url: url)
        }
    }
    
    func makeTableView() -> UITableView {
        return adapter.makeTableView()
    }
    
}

extension SettingsVM: MFMailComposeViewControllerDelegate {
    
}
