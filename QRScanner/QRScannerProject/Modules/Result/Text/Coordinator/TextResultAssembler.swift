//
//  TextResultAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class TextResultAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: TextResultCoordinatorProtocol,
                     dto: TextQrCodeDTO
    ) -> UIViewController {
        
        let alertService = TextResultAlertServiceUseCase(
            service: container.resolve())
        let fileManager = TextResultFileManagerServiceUseCase(
            fileManager: container.resolve())
        let storage = TextResultQrCodeStorageUseCase(
            storage: container.resolve())
        
        let vm = TextResultVM(coordinator: coordinator,
                              alertService: alertService,
                              fileManager: fileManager,
                              storage: storage,
                              dto: dto)
        let vc = TextResultVC(viewModel: vm)
        return vc
    }
    
}

