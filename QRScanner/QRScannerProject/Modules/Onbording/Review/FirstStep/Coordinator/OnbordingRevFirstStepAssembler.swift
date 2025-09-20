//
//  OnbordingRevFirstStepAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

final class OnbordingRevFirstStepAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: OnbordingRevFirstStepCoordinatorProtocol
    ) -> UIViewController {
        let vm = OnbordingRevFirstStepVM(coordinator: coordinator,
                                         timer: container.resolve())
        let vc = OnbordingRevFirstStepVC(viewModel: vm)
        return vc
    }
    
}
