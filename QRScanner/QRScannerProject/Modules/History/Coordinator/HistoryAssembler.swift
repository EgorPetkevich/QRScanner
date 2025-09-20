//
//  HistoryAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import Storage

final class HistoryAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: HistoryCoordinatorProtocol
    ) -> UIViewController {
        
        let adapter: HistoryAdapter = container.resolve()
        let storage = HistoryQrCodeStorageUseCase(storage: container.resolve())
                
        let vm = HistoryVM(coordinator: coordinator,
                           adapter: adapter,
                           frcService: makeFRC(),
                           storage: storage)
        let vc = HistoryVC(viewModel: vm)
        return vc
    }
    
    private static func makeFRC() -> FRCService<BaseQrCodeDTO> {
        .init { request in
            request.sortDescriptors = [.QrCode.byDate]
        }
    }
    
}
