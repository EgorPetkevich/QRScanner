//
//  PaywallProdTrialAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class PaywallProdTrialAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PaywallProdTrialCoordinatorProtocol,
                     pageControlIsHiden: Bool
    ) -> UIViewController {
        
        let adaptyService = PaywallProdTrialAdaptyService(service: container.resolve())
        let alertService = PaywallProdTrialAlertServiceUseCase(service: container.resolve())
        
        let vm = PaywallProdTrialVM(coordinator: coordinator,
                                    adaptyService: adaptyService,
                                    alertService: alertService,
                                    timer: container.resolve())
        let vc = PaywallProdTrialVC(viewModel: vm,
                                    pageControlIsHiden: pageControlIsHiden)
        return vc
    }
    
}

