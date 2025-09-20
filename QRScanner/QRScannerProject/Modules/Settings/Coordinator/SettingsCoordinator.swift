//
//  SettingsCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import MessageUI

final class SettingsCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let vc = SettingsAssembler.make(container: container, coordinator: self)
        self.rootVC = vc
        return vc
    }
    
    
}

extension SettingsCoordinator: SettingsCoordinatorProtocol {
    
    func shareApp(url: URL) {
        let shareSheetVC = UIActivityViewController(activityItems: [url],
                                                    applicationActivities: nil)
        
        self.rootVC?.present(shareSheetVC, animated: true)
    }
    
    func emailDidSelect() {
        guard rootVC?.presentedViewController == nil else { return }

        guard let rootVC else  { return }
        let coordinator = MailCoordinator(rootVC: rootVC)
        children.append(coordinator)
        
        guard let mailVC = coordinator.start() else { return }
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            mailVC.dismiss(animated: true)
        }
        
        rootVC.present(mailVC, animated: true)
    }
    
}


