//
//  PaywallProdCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class PaywallProdCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let pageControlIsHiden: Bool
    
    init(container: Container, pageControlIsHiden: Bool) {
        self.container = container
        self.pageControlIsHiden = pageControlIsHiden
    }
    
    override func start() -> UIViewController {
        let vc = PaywallProdAssembler.make(container: container,
                                           coordinator: self,
                                           pageControlIsHiden: pageControlIsHiden)
        self.rootVC = vc
        return vc
    }
    
}


extension PaywallProdCoordinator: PaywallProdCoordinatorProtocol {}
