//
//  OnbordingRevThirdStepCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class OnbordingRevThirdStepCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let onbordingType: Onbording.Options
    
    init(container: Container, onbordingType: Onbording.Options) {
        self.container = container
        self.onbordingType = onbordingType
    }

    
    override func start() -> UIViewController {
        let vc = OnbordingRevThirdStepAssembler.make(container: container,
                                                     coordinator: self)
        self.rootVC = vc
        return vc
    }
    
}


extension OnbordingRevThirdStepCoordinator:
    OnbordingRevThirdStepCoordinatorProtocol {
    
    func nextStep() {
        self.finish()
        //MARK: - Review
//        openPaywallRev()
    }
    
    private func openPaywallRev() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.finish()
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc)
    }
    
}

