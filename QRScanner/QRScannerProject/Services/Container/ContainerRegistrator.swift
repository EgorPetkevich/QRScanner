//
//  ContainerRegistrator.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import Foundation
import Storage

final class ContainerRegistrator {
    
    static func makeContainer() -> Container {
        let container = Container()
        
        container.register { Timer() }
        container.register { AlertService(container: container)}
        container.register { QRCodeService(
            networkService: NetworkService(),
            fileManager: FileManagerService.instansce)}
        container.register { BarcodeService(
            service: NetworkService(),
            session: NetworkSessionProvider(),
            fileManager: FileManagerService.instansce) }
        container.register { AllQrCodeStorage() }
        container.register { FileManagerService.instansce }
        container.register { SettingsAdapter() }
        container.register {  HistoryAdapter() }
        container.register { AdaptyService.instansce }
        
        return container
    }
    
}
