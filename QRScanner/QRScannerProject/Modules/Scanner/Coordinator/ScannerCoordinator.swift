//
//  ScannerCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import Storage

final class ScannerCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    override func start() -> UIViewController {
        let vc = ScannerAssembler.make(container: container,
                                       coordinator: self)
        rootVC = vc
        return vc
    }
    
}

extension ScannerCoordinator: ScannerCoordinatorProtocol {
   
    func showPaywallReview() {
        let coordinator =
        PaywallReviewCoordinator(container: container)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func showPaywallProdTrial() {
        let coordinator =
        PaywallProdTrialCoordinator(container: container,
                                    pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func showPaywallProd() {
        let coordinator =
        PaywallProdCoordinator(container: container,
                               pageControlIsHiden: true)
        let vc = coordinator.start()
        
        children.append(coordinator)
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismiss(animated: true)
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.present(vc, animated: true)
    }
    
    func hideMenu() {
        rootVC?.presentedViewController?.dismiss(animated: true)
    }
    
    func showImagePicker(delegate: any UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = delegate
        rootVC?.present(imagePickerVC, animated: true)
    }
    
    func showMenu(sender: UIView, delegate: ScannerMenuDelegate) {
        let menu = ScannerMenuBuilder.build(delegate: delegate,
                                            sourceView: sender)
        rootVC?.present(menu, animated: true)
    }
    
    func qrCodeDidFound(dto: any DTODescription) {
        rootVC?.presentedViewController?.dismiss(animated: true)
        switch dto {
        case is PhoneQrCodeDTO:
            openPhoneResult(dto: dto as! PhoneQrCodeDTO)
        case is UrlQrCodeDTO:
            openLinkResult(dto: dto as! UrlQrCodeDTO)
        case is TextQrCodeDTO:
            openTextResult(dto: dto as! TextQrCodeDTO)
        case is BarcodeDTO:
            openBarcodeResult(dto: dto as! BarcodeDTO)
        default:
            return
        }
    }
    
    func openPhoneResult(dto: PhoneQrCodeDTO) {
        let coordinator = PhoneResultCoordinator(container: container,
                                                 dto: dto)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismissDetail()
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc)
    }
    
    func openLinkResult(dto: UrlQrCodeDTO) {
        let coordinator = LinkResultCoordinator(container: container,
                                                dto: dto)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismissDetail()
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc)
    }
    
    func openTextResult(dto: TextQrCodeDTO) {
        let coordinator = TextResultCoordinator(container: container,
                                                dto: dto)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismissDetail()
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc)
    }
    
    func openBarcodeResult(dto: BarcodeDTO) {
        let coordinator = BarcodeResultCoordinator(container: container,
                                                   dto: dto)
        children.append(coordinator)
        
        let vc = coordinator.start()
        
        coordinator.onDidFinish = { [weak self] coordinator in
            self?.children.removeAll {$0 == coordinator}
            vc.dismissDetail()
        }
        
        vc.modalPresentationStyle = .fullScreen
        rootVC?.presentDetail(vc)
    }
    
}
