//
//  PaywallProdAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class PaywallProdAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PaywallProdCoordinatorProtocol,
                     pageControlIsHiden: Bool
    ) -> UIViewController {
        
        let adaptyService = PaywallProdAdaptyService(service: container.resolve())
        
        let alertService = PaywallProdAlertServiceUseCase(service: container.resolve())
        
        let vm = PaywallProdVM(coordinator: coordinator,
                               adaptyService: adaptyService,
                               alertService: alertService,
                               timer: container.resolve())
        let vc = PaywallProdVC(viewModel: vm,
                               pageControlIsHiden: pageControlIsHiden)
        return vc
    }
    
}
