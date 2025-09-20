//
//  PaywallReviewCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class PaywallReviewCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let vc = PaywallReviewAssembler.make(container: container,
                                             coordinator: self)
        self.rootVC = vc
        return vc
    }
    
}


extension PaywallReviewCoordinator: PaywallReviewCoordinatorProtocol { }

