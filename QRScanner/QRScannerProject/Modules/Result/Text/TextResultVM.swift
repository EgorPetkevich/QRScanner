//
//  TextResualtVM.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

protocol TextResultCoordinatorProtocol: AnyObject {
    func presentShareSheet(str: String)
    func presentCopiedVC(sender: UIView)
    func finish()
}

protocol TextResultAlertServiceUseCaseProtocol {
    func showActionSheet(actionTitle: String,
                         actionHandler: @escaping () -> Void,
                         deleteTitle: String,
                         deleteHandler: @escaping () -> Void,
                         cancelTitle: String )
}

protocol TextResultFileManagerServiceUseCaseProtocol {
    func read(with path: String) -> UIImage?
}

protocol TextResultQrCodeStorageUseCaseProtocol {
    func delete(dto: any DTODescription)
}

final class TextResultVM: TextResultViewModelProtocol {
    
    private var dto: TextQrCodeDTO

    weak var coordinator: TextResultCoordinatorProtocol?
    private var alertService: TextResultAlertServiceUseCaseProtocol
    private let fileManager: TextResultFileManagerServiceUseCaseProtocol
    private let storage: TextResultQrCodeStorageUseCaseProtocol
    
    init(coordinator: TextResultCoordinatorProtocol,
         alertService: TextResultAlertServiceUseCaseProtocol,
         fileManager: TextResultFileManagerServiceUseCaseProtocol,
         storage: TextResultQrCodeStorageUseCaseProtocol,
         dto: TextQrCodeDTO) {
        self.coordinator = coordinator
        self.alertService = alertService
        self.fileManager = fileManager
        self.storage = storage
        self.dto = dto
    }
    
    func getText() -> String {
        dto.text
    }
    
    func getQRImage() -> UIImage {
        fileManager.read(with: dto.id) ?? .Result.stubImage
    }
    
    func copyButtonDidTap(sender: UIView) {
        UIPasteboard.general.string = dto.text
        coordinator?.presentCopiedVC(sender: sender)
    }
    
    func actionButtonDidTap() {
        if
            let strUrl = dto.strUrl,
            let url = URL(string: strUrl),
            UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        } else {
            print("[TextResultVM]: Error - cannot open URL")
        }
    }
    
    func arrowButtonDidTap() {
        coordinator?.finish()
    }
    
    func menuButtonDidTap() {
        alertService.showActionSheet(actionTitle: "Export",
                                     actionHandler: { [weak self] in
            if
                let dto = self?.dto {
                self?.coordinator?.presentShareSheet(str: dto.text)
            }
            
        }, deleteTitle: "Delete", deleteHandler: { [weak self] in
            guard let dto = self?.dto else { return }
            self?.storage.delete(dto: dto)
            self?.coordinator?.finish()
            
        }, cancelTitle: "Cancel")
    }
    
}
