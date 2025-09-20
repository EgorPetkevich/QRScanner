//
//  HistoryCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import Storage

final class HistoryCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private var container: Container
    private var coordinator: MainTabBarCoordinatorProtocol
    
    init(container: Container, 
         coordinator: MainTabBarCoordinatorProtocol) {
        self.container = container
        self.coordinator = coordinator
    }
    
    override func start() -> UIViewController {
        let vc = HistoryAssembler.make(container: container, coordinator: self)
        rootVC = vc
        return vc
    }
    
}

extension HistoryCoordinator: HistoryCoordinatorProtocol {
    
    func presentShareSheet(content: [URL]) {
        let shareSheetVC = UIActivityViewController(activityItems: content,
                                                    applicationActivities: nil)

        self.rootVC?.present(shareSheetVC, animated: true)
    }
    
    func resultDidSelect(dto: any DTODescription) {
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
    
    func openScanner() {
        coordinator.scanerDidTap()
    }
    
}

