//
//  PaywallReviewAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class PaywallReviewAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: PaywallReviewCoordinatorProtocol
    ) -> UIViewController {
        
        let adaptyService = PaywallReviewAdaptyService(service: container.resolve())
        let alertService = PaywallReviewAlertServiceUseCase(service: container.resolve())
        
        let vm = PaywallReviewVM(coordinator: coordinator, 
                                 adaptyService: adaptyService,
                                 alertService: alertService,
                                 timer: container.resolve())
        let vc = PaywallReviewVC(viewModel: vm)
        return vc
    }
    
}
