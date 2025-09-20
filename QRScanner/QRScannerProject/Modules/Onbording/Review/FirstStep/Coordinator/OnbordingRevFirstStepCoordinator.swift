//
//  OnbordingRevFirstStepCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class OnbordingRevFirstStepCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private let container: Container
    private let onbordingType: Onbording.Options
    
    init(container: Container, onbordingType: Onbording.Options) {
        self.container = container
        self.onbordingType = onbordingType
    }
    
    override func start() -> UIViewController {
        let vc = OnbordingRevFirstStepAssembler.make(container: container,
                                                     coordinator: self)
        self.rootVC = vc
        return vc
    }
    
}


extension OnbordingRevFirstStepCoordinator:
    OnbordingRevFirstStepCoordinatorProtocol {
    
    func nextStep() {
        let coordinator =
        OnbordingRevSecondStepCoordinator(container: container,
                                          onbordingType: onbordingType)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
            self?.finish()
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc)
    }
    
}

