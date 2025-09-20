//
//  MainTabBarAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit

final class MainTabBarAssembler {
    
    private init() {}
    
    static func make(
        coordinator: MainTabBarCoordinatorProtocol
    ) -> UITabBarController {
        let vm = MainTabBarVM(coordinator: coordinator)
        let vc = MainTabBarVC(viewModel: vm)
        return vc
    }
    
}
