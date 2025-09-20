//
//  OnbordingRevSecondStepCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class OnbordingRevSecondStepCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let onbordingType: Onbording.Options
    
    init(container: Container, onbordingType: Onbording.Options) {
        self.container = container
        self.onbordingType = onbordingType
    }
    
    override func start() -> UIViewController {
        let vc = OnbordingRevSecondStepAssembler.make(container: container,
                                                      coordinator: self)
        rootVC = vc
        return vc
    }
    
}


extension OnbordingRevSecondStepCoordinator:
    OnbordingRevSecondStepCoordinatorProtocol {
    
    func nextStep() {
        let coordinator =
        OnbordingRevThirdStepCoordinator(container: container,
                                      onbordingType: onbordingType)
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

