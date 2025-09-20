//
//  BarcodeResultCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class BarcodeResultCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private var container: Container
    private var dto: BarcodeDTO
    
    init(container: Container, dto: BarcodeDTO) {
        self.container = container
        self.dto = dto
    }
    
    override func start() -> UIViewController {
        let vc = BarcodeResultAssembler.make(container: container,
                                             coordinator: self,
                                             dto: dto)
        rootVC = vc
        return vc
    }
    
}

extension BarcodeResultCoordinator: BarcodeResultCoordinatorProtocol {
    
    func presentCopiedVC(sender: UIView) {
        let vc = CopiedPopoverBuilder.buildCopiedVC(sourseView: sender)
        rootVC?.present(vc, animated: true)
    }
    
    func presentShareSheet(url: URL) {
        let shareSheetVC = UIActivityViewController(activityItems: [url],
                                                    applicationActivities: nil)
        rootVC?.present(shareSheetVC, animated: true)
    }
    
}

