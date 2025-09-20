//
//  BarcodeResultAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class BarcodeResultAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: BarcodeResultCoordinatorProtocol,
                     dto: BarcodeDTO
    ) -> UIViewController {
        
        let alertService = BarcodeResultAlertServiceUseCase(
            service: container.resolve())
        let fileManager = BarcodeResultFileManagerServiceUseCase(
            fileManager: container.resolve())
        let storage = BarcodeResultQrCodeStorageUseCase(
            storage: container.resolve())
        
        let vm = BarcodeResultVM(coordinator: coordinator,
                                 alertService: alertService,
                                 fileManager: fileManager,
                                 storage: storage,
                                 dto: dto)
        let vc = BarcodeResultVC(viewModel: vm)
        return vc
    }
    
}

