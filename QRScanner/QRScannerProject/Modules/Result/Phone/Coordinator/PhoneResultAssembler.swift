//
//  PhoneResultAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class PhoneResultAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PhoneResultCoordinatorProtocol,
                     dto: PhoneQrCodeDTO
    ) -> UIViewController {
        
        let alertService = PhoneResultAlertServiceUseCase(
            service: container.resolve())
        let fileManager = PhoneResultFileManagerServiceUseCase(
            fileManager: container.resolve())
        let storage = PhoneResultQrCodeStorageUseCase(
            storage: container.resolve())
        
        let vm = PhoneResultVM(coordinator: coordinator,
                               alertService: alertService,
                               fileManager: fileManager,
                               storage: storage,
                               dto: dto)
        let vc = PhoneResultVC(viewModel: vm)
        return vc
    }
    
}
