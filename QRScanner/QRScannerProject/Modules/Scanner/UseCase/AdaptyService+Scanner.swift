//
//  AdaptyService+Scanner.swift
//  QRScanner
//
//  Created by George Popkich on 15.08.24.
//

import Foundation

struct ScannerAdaptyServiceUseCase: ScannerAdaptyServiceUseCaseProtocol {
 
    let service: AdaptyService
    
    var isPremium: Bool
    var remoteConfig: RemoteConfig?
    
    init(service: AdaptyService) {
        self.service = service
        self.isPremium = self.service.isPremium
        self.remoteConfig = self.service.remoteConfig
    }
    
}
