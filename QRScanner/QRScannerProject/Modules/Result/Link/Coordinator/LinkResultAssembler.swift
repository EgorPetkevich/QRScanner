//
//  LinkResultAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class LinkResultAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: LinkResultCoordinatorProtocol,
                     dto: UrlQrCodeDTO
    ) -> UIViewController {
        
        let alertService = LinkResultAlertServiceUseCase(
            service: container.resolve())
        
        let fileManager =  LinkResultFileManagerServiceUseCase(
            fileManager: container.resolve())
        let storage = LinkResultQrCodeStorageUseCase(
            storage: container.resolve())
        
        let vm = LinkResultVM(coordinator: coordinator,
                              alertService: alertService,
                              fileManager: fileManager,
                              storage: storage,
                              dto: dto)
        let vc = LinkResultVC(viewModel: vm)
        return vc
    }
    
}
