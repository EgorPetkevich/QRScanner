//
//  TextResultCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class TextResultCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private var container: Container
    private var dto: TextQrCodeDTO
    
    init(container: Container, dto: TextQrCodeDTO) {
        self.container = container
        self.dto = dto
    }
    
    override func start() -> UIViewController {
        let vc = TextResultAssembler.make(container: container,
                                          coordinator: self,
                                          dto: dto)
        rootVC = vc
        return vc
    }
    
}

extension TextResultCoordinator: TextResultCoordinatorProtocol {
    
    func presentCopiedVC(sender: UIView) {
        let vc = CopiedPopoverBuilder.buildCopiedVC(sourseView: sender)
        rootVC?.present(vc, animated: true)
    }
    
    func presentShareSheet(str: String) {
        let shareSheetVC = UIActivityViewController(activityItems: [str],
                                                    applicationActivities: nil)
        rootVC?.present(shareSheetVC, animated: true)
    }
    
}
