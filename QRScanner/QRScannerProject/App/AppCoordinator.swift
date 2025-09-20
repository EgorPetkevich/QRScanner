//
//  AppCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    private var adaptyService: AdaptyService
    private let container: Container
    private let windowManager: WindowManager
    
    init(container: Container) {
        self.container = container
        self.windowManager = container.resolve()
        self.adaptyService = container.resolve()
    }
    
    func getCurrentViewController() -> UIViewController? {
        let currentVC = windowManager.get(type: .main).rootViewController
        if currentVC is MainTabBarVC {
            dismissPresentedVC(on: currentVC)
            return currentVC
        }
        return nil
    }

    func showLaunchScreen() {
        let coordinator = LaunchCoordanator()
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.startApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    func startFromForeground() {
        guard adaptyService.isPremium == false else { return }
        guard let remoteConfig = adaptyService.remoteConfig else { return }
        
        let review = remoteConfig.review
            
        if review {
            guard
                let currentVC = self.getCurrentViewController(),
                ParametersHelper.get(.reviewWasShown) == true
            else { return }
            let paywallReview = self.getPaywallReview()
            paywallReview.modalPresentationStyle = .fullScreen
            currentVC.present(paywallReview, animated: true)
        } else if review == false {
            guard
                let currentVC = self.getCurrentViewController(),
                ParametersHelper.get(.prodWasShow) == true
            else { return }
            let supportTrial = remoteConfig.supportTrial
            let prodPaywall = self.getProduction(supportTrial: supportTrial)
            prodPaywall.modalPresentationStyle = .fullScreen
            currentVC.present(prodPaywall, animated: true)
        }
        
    }
    
    func startApp() {
        if !ParametersHelper.get(.createQrCodeImagesDirectory) {
            FileManagerService.creatDierectory(name: .qrCodeImages)
            ParametersHelper.set(.createQrCodeImagesDirectory, value: true)
        }
        
        openOnbordingReview()
        
//        adaptyService.checkStatus { [weak self] isPremium in
//            guard let isPremium else { return }
//            self?.adaptyService.getRemoteConfig { remoteConfig in
//                guard
//                    let review = remoteConfig?.review,
//                    let closeTimer = remoteConfig?.closeTimer
//                else { return }
//                ParametersHelper.setTimer(closeTimer)
//                
//                if review {
//                    if !ParametersHelper.get(.reviewWasShown) {
//                        self?.openOnbordingReview()
//                    } else {
//                        if !isPremium { self?.openPaywallReview() } else { self?.openMainApp() }
//                    }
//                    return
//                    
//                } else if review == false {
//                    guard
//                        let supportTrial = remoteConfig?.supportTrial
//                    else { return }
//                    
//                    self?.openProduction(supportTrial: supportTrial,
//                                         isPremium: isPremium)
//                }
//            }
//        }
    }
    
    
    private func openMainApp() {
        let coordinator = MainTabBarCoordinator(container: container)
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.startApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    private func openOnbordingReview() {
        let coordinator =
        OnbordingRevFirstStepCoordinator(
            container: container,
            onbordingType: Onbording.Options.review
        )
        children.append(coordinator)
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
        }
        let vc = coordinator.start()
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    
    private func openPaywallReview() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
            vc.dismiss(animated: true)
        }
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    private func openPaywallProd() {
        let coordinator =
        PaywallProdCoordinator(container: container, 
                               pageControlIsHiden: false)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
            vc.dismiss(animated: true)
        }
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    private func openPaywallProdTrial() {
        let coordinator =
        PaywallProdTrialCoordinator(container: container, 
                                    pageControlIsHiden: false)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            self?.openMainApp()
            vc.dismiss(animated: true)
        }
        
        let window = windowManager.get(type: .main)
        window.rootViewController = vc
        windowManager.show(type: .main)
    }
    
    func getPaywallReview() -> UIViewController {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        return vc
    }
    
    func getPaywallProdTrial() -> UIViewController {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        return vc
    }
    
    func getPaywallProd() -> UIViewController {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        return vc
    }
    
    private func getProduction(supportTrial: Bool) -> UIViewController {
        if supportTrial {
            return getPaywallProdTrial()
        } else {
            return getPaywallProd()
        }
    }
    
    private func dismissPresentedVC(on currentVC: UIViewController?) {
        if
            currentVC?.presentedViewController is BarcodeResultVC ||
            currentVC?.presentedViewController is LinkResultVC ||
            currentVC?.presentedViewController is PhoneResultVC ||
            currentVC?.presentedViewController is TextResultVC
        {
            return
        } else {
            currentVC?.presentedViewController?.dismiss(animated: true)
        }
        
    }
    
}
