//
//  OnbordingRevSecondStepAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class OnbordingRevSecondStepAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: OnbordingRevSecondStepCoordinatorProtocol
    ) -> UIViewController {
        let vm = OnbordingRevSecondStepVM(coordinator: coordinator,
                                          timer: container.resolve())
        let vc = OnbordingRevSecondStepVC(viewModel: vm)
        return vc
    }
    
}
