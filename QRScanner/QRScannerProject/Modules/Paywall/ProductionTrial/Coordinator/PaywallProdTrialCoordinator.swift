//
//  PaywallProdTrialCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class PaywallProdTrialCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let pageControlIsHiden: Bool
    
    init(container: Container, pageControlIsHiden: Bool) {
        self.container = container
        self.pageControlIsHiden = pageControlIsHiden
    }
    
    override func start() -> UIViewController {
        let vc = PaywallProdTrialAssembler.make(container: container,
                                                coordinator: self,
                                                pageControlIsHiden: pageControlIsHiden)
        self.rootVC = vc
        return vc
    }
    
}


extension PaywallProdTrialCoordinator:
    PaywallProdTrialCoordinatorProtocol {
    
    func nextStep() {
        finish()
    }
    
}
