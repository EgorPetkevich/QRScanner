//
//  BarcodeResultVM.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

protocol BarcodeResultCoordinatorProtocol: AnyObject {
    func presentShareSheet(url: URL)
    func presentCopiedVC(sender: UIView)
    func finish()
}

protocol BarcodeResultAlertServiceUseCaseProtocol {
    func showActionSheet(actionTitle: String,
                         actionHandler: @escaping () -> Void,
                         deleteTitle: String,
                         deleteHandler: @escaping () -> Void,
                         cancelTitle: String )
}

protocol BarcodeResultFileManagerServiceUseCaseProtocol {
    func read(with path: String) -> UIImage?
}

protocol BarcodeResultQrCodeStorageUseCaseProtocol {
    func delete(dto: any DTODescription)
}

final class BarcodeResultVM: BarcodeResultViewModelProtocol {
    
    private var dto: BarcodeDTO

    weak var coordinator: BarcodeResultCoordinatorProtocol?
    private var alertService: BarcodeResultAlertServiceUseCaseProtocol
    private let fileManager: BarcodeResultFileManagerServiceUseCaseProtocol
    private let storage: BarcodeResultQrCodeStorageUseCaseProtocol
    
    init(coordinator: BarcodeResultCoordinatorProtocol,
         alertService: BarcodeResultAlertServiceUseCaseProtocol,
         fileManager: BarcodeResultFileManagerServiceUseCaseProtocol,
         storage: BarcodeResultQrCodeStorageUseCaseProtocol,
         dto: BarcodeDTO) {
        self.coordinator = coordinator
        self.alertService = alertService
        self.fileManager = fileManager
        self.storage = storage
        self.dto = dto
    }
    
    func getText() -> String {
        dto.barcode
    }
    
    func getQRImage() -> UIImage {
        fileManager.read(with: dto.id) ?? .Result.stubImage
    }
    
    func copyBarcodeButtonDidTap(sender: UIView) {
        UIPasteboard.general.string = dto.barcode
        coordinator?.presentCopiedVC(sender: sender)
    }
    
    func copyLinkButtonDidTap(sender: UIView) {
        UIPasteboard.general.string = dto.strUrl
        coordinator?.presentCopiedVC(sender: sender)
    }
    
    func getProductName() -> String {
        dto.title
    }
    
    func getStrUrl() -> String {
        dto.strUrl
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
            if
                let dto = self?.dto,
                let url = URL(string: dto.strUrl) {
                self?.coordinator?.presentShareSheet(url: url)
            }
           
        }, deleteTitle: "Delete", deleteHandler: { [weak self] in
            guard let dto = self?.dto else { return }
            self?.storage.delete(dto: dto)
            self?.coordinator?.finish()
        }, cancelTitle: "Cancel")
    }
    
}

