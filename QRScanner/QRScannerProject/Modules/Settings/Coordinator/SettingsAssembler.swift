//
//  SettingsAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import MessageUI

final class SettingsAssembler {
    
    private init() {}
    
    static func make(container: Container,
                     coordinator: SettingsCoordinatorProtocol
    ) -> UIViewController {
        let adapter: SettingsAdapter = container.resolve()
        
        let vm = SettingsVM(coordinator: coordinator, adapter: adapter)
        let vc = SettingsVC(viewModel: vm)
        
        return vc
    }
    
}
