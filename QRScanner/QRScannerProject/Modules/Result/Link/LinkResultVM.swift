//
//  LinkResultVM.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

protocol LinkResultCoordinatorProtocol: AnyObject {
    func presentShareSheet(url: URL)
    func presentCopiedVC(sender: UIView)
    func finish()
}

protocol LinkResultAlertServiceUseCaseProtocol {
    func showActionSheet(actionTitle: String,
                         actionHandler: @escaping () -> Void,
                         deleteTitle: String,
                         deleteHandler: @escaping () -> Void,
                         cancelTitle: String )
}

protocol LinkResultFileManagerServiceUseCaseProtocol {
    func read(with path: String) -> UIImage?
}

protocol LinkResultQrCodeStorageUseCaseProtocol {
    func delete(dto: any DTODescription)
}

final class LinkResultVM: LinkResultViewModelProtocol {
    
    private var dto: UrlQrCodeDTO

    weak var coordinator: LinkResultCoordinatorProtocol?
    private var alertService: LinkResultAlertServiceUseCaseProtocol
    private let fileManager: LinkResultFileManagerServiceUseCaseProtocol
    private let storage: LinkResultQrCodeStorageUseCaseProtocol
    
    init(coordinator: LinkResultCoordinatorProtocol,
         alertService: LinkResultAlertServiceUseCaseProtocol,
         fileManager: LinkResultFileManagerServiceUseCaseProtocol,
         storage: LinkResultQrCodeStorageUseCaseProtocol,
         dto: UrlQrCodeDTO) {
        self.coordinator = coordinator
        self.alertService = alertService
        self.fileManager = fileManager
        self.storage = storage
        self.dto = dto
    }
    
    func getText() -> String {
        dto.strUrl
    }
    
    func getQRImage() -> UIImage {
        fileManager.read(with: dto.id) ?? .Result.stubImage
    }
    
    func copyButtonDidTap(sender: UIView) {
        UIPasteboard.general.string = dto.strUrl
        coordinator?.presentCopiedVC(sender: sender)
    }
    
    func actionButtonDidTap() {
        if let url = URL(string: dto.strUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("[LinkResultVM]: Error - cannot open URL")
        }
    }
    
    func arrowButtonDidTap() {
        coordinator?.finish()
    }
    
    func menuButtonDidTap() {
        alertService.showActionSheet(actionTitle: "Export",
                                     actionHandler: { [weak self] in
            if let dto = self?.dto, let url = URL(string: dto.strUrl) {
                self?.coordinator?.presentShareSheet(url: url)
            }
           
        }, deleteTitle: "Delete", deleteHandler: {  [weak self] in
            guard let dto = self?.dto else { return }
            self?.storage.delete(dto: dto)
            self?.coordinator?.finish()
        }, cancelTitle: "Cancel")
    }
    
}
