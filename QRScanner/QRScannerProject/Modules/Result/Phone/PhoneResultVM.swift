//
//  PhoneResultVM.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

protocol PhoneResultCoordinatorProtocol: AnyObject {
    func presentShareSheet(url: URL)
    func presentCopiedVC(sender: UIView)
    func finish()
}

protocol PhoneResultAlertServiceUseCaseProtocol {
    func showActionSheet(actionTitle: String,
                         actionHandler: @escaping () -> Void,
                         deleteTitle: String,
                         deleteHandler: @escaping () -> Void,
                         cancelTitle: String )
}
 
protocol PhoneResultFileManagerServiceUseCaseProtocol {
    func read(with path: String) -> UIImage?
}

protocol PhoneResultQrCodeStorageUseCaseProtocol {
    func delete(dto: any DTODescription)
}

final class PhoneResultVM: PhoneResultViewModelProtocol {
    
    private var dto: PhoneQrCodeDTO

    weak var coordinator: PhoneResultCoordinatorProtocol?
    private var alertService: PhoneResultAlertServiceUseCaseProtocol
    private let fileManager: PhoneResultFileManagerServiceUseCaseProtocol
    private let storage: PhoneResultQrCodeStorageUseCaseProtocol
    
    init(coordinator: PhoneResultCoordinatorProtocol,
         alertService: PhoneResultAlertServiceUseCaseProtocol,
         fileManager: PhoneResultFileManagerServiceUseCaseProtocol,
         storage: PhoneResultQrCodeStorageUseCaseProtocol,
         dto: PhoneQrCodeDTO) {
        self.coordinator = coordinator
        self.alertService = alertService
        self.fileManager = fileManager
        self.storage = storage
        self.dto = dto
    }
    
    
    func getText() -> String {
        dto.phone
    }
    
    func getQRImage() -> UIImage {
        fileManager.read(with: dto.id) ?? .Result.stubImage
    }
    
    func copyButtonDidTap(sender: UIView) {
        UIPasteboard.general.string = dto.phone
        coordinator?.presentCopiedVC(sender: sender)
    }
    
    func actionButtonDidTap() {
        if
            let phoneURL = URL(string: "tel://" + dto.phone),
            UIApplication.shared.canOpenURL(phoneURL)
        {
            UIApplication.shared.open(phoneURL)
        } else {
            print("[PhoneResultVM]: Error - cannot call PhoneNumber")
        }
    }
    
    func arrowButtonDidTap() {
        coordinator?.finish()
    }
    
    func menuButtonDidTap() {
        alertService.showActionSheet(actionTitle: "Export",
                                     actionHandler: { [weak self] in
            if
                let dto = self?.dto,
                let url = URL(string: "tel://" + dto.phone) {
                self?.coordinator?.presentShareSheet(url: url)
            }
            
        }, deleteTitle: "Delete", deleteHandler: { [weak self] in
            guard let dto = self?.dto else { return }
            self?.storage.delete(dto: dto)
            self?.coordinator?.finish()
        }, cancelTitle: "Cancel")
    }
    
}
