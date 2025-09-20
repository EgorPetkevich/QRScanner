//
//  ScannerAssembler.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import AVFoundation

final class ScannerAssembler {
    
    private init() {}
    
    static func make(container: Container, 
                     coordinator: ScannerCoordinatorProtocol
    ) -> UIViewController {
        
        let alertService = ScannerAlertServiceUseCase(
            alertService: container.resolve())
        let qrCodeService = QRCodeServiceUseCase(
            service: container.resolve())
        let barcodeService = ScannerBarcodeServiceUseCase(
            service: container.resolve())
        let storage = ScannerQrCodeStorageUseCase(
            storage: container.resolve())
        let adaptyService = ScannerAdaptyServiceUseCase(
            service: container.resolve())
       
        let vm = ScannerVM(coordinator: coordinator,
                           alertServise: alertService,
                           captureSession: AVCaptureSession(),
                           flashSettings: AVCapturePhotoSettings(),
                           qrCodeService: qrCodeService,
                           timer: container.resolve(),
                           barcodeService: barcodeService,
                           storage: storage,
                           adaptyService: adaptyService )
        let vc = ScannerVC(viewModel: vm)
        return vc
    }
    
}
