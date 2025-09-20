//
//  MainTabBarCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    private enum TabBarItems: Int {
        case history
        case scaner
        case setting
    }
    
    private var rootVC: UIViewController?
    private let container: Container
    private var tabBar: UITabBarController?
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let tabBar = MainTabBarAssembler.make(coordinator: self)
        tabBar.viewControllers = [makeHistoryModule(),
                                  makeScanerModule(),
                                  makeSettingsModule()]

        tabBar.selectedIndex = TabBarItems.scaner.rawValue
        self.tabBar = tabBar
        rootVC = tabBar
        return tabBar
    }
    
    private func makeHistoryModule() -> UIViewController {
        let coordinator = HistoryCoordinator(container: container,
                                             coordinator: self)
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {coordinator == $0}
            self?.finish()
        }
        let vc = coordinator.start()
        return vc
    }
    
    private func makeScanerModule() -> UIViewController {
        let coordinator = ScannerCoordinator(container: container)
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {coordinator == $0}
            self?.finish()
        }
        let vc = coordinator.start()
        return vc
    }
    
    private func makeSettingsModule() -> UIViewController {
        let coordinator = SettingsCoordinator(container: container)
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {coordinator == $0}
            self?.finish()
        }
        let vc = coordinator.start()
        return vc
    }
    
}

extension MainTabBarCoordinator: MainTabBarCoordinatorProtocol {
    
    func scanerDidTap() {
        tabBar?.selectedIndex = TabBarItems.scaner.rawValue
    }
    
}
