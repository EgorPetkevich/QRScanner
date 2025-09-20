//
//  MainTabBarVM.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit

protocol MainTabBarCoordinatorProtocol: AnyObject {
    func scanerDidTap()
}

final class MainTabBarVM: MainTabBarViewModelProtocol {
    
    private weak var coordinator: MainTabBarCoordinatorProtocol?
    
    init(coordinator: MainTabBarCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func scanerButtonDidTap() {
        coordinator?.scanerDidTap()
    }
    
}
