//
//  OnbordingRevThirdStepAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class OnbordingRevThirdStepAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: OnbordingRevThirdStepCoordinatorProtocol
    ) -> UIViewController {
        let vm = OnbordingRevThirdStepVM(coordinator: coordinator,
                                         timer: container.resolve())
        let vc = OnbordingRevThirdStepVC(viewModel: vm)
        return vc
    }
    
}
