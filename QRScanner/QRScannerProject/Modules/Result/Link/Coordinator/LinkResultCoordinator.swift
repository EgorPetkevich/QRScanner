//
//  LinkResultCoordinator.swift
//  QRScanner
//
//  Created by George Popkich on 24.07.24.
//

import UIKit
import Storage

final class LinkResultCoordinator: Coordinator {
    
    private var rootVC: UIViewController?
    private var container: Container
    private var dto: UrlQrCodeDTO
    
    init(container: Container, dto: UrlQrCodeDTO) {
        self.container = container
        self.dto = dto
    }
    
    override func start() -> UIViewController {
        let vc = LinkResultAssembler.make(container: container,
                                          coordinator: self,
                                          dto: dto)
        rootVC = vc
        return vc
    }
    
}

extension LinkResultCoordinator: LinkResultCoordinatorProtocol {
    
    
    func presentCopiedVC(sender: UIView) {
        let vc = CopiedPopoverBuilder.buildCopiedVC(sourseView: sender)
        rootVC?.present(vc, animated: true)
    }
        
    func presentShareSheet(url: URL) {
        let shareSheetVC = UIActivityViewController(activityItems: [url],
                                                    applicationActivities: nil)

        self.rootVC?.present(shareSheetVC, animated: true)
    }
    
}
