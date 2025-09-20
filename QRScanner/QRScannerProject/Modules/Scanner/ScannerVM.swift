//
//  ScanerVM.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import AVFoundation
import Storage

protocol ScannerCoordinatorProtocol: AnyObject {
    func qrCodeDidFound(dto: any DTODescription)
    func showMenu(sender: UIView, delegate: ScannerMenuDelegate)
    func showImagePicker(delegate: any UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    func showPaywallReview()
    func showPaywallProdTrial()
    func showPaywallProd()
    func hideMenu()
}

protocol ScannerAlertServiceUseCaseProtocol {
    func hideAlert()
    func showQRNoFoundAlert(title: String, okTitle: String)
    func showCameraError(title: String,
                         message: String,
                         goSettings: String,
                         goSettingsHandler: @escaping () -> Void)
    func showBarcodeInput(title: String,
                          actionTitle: String,
                          cancelTitle: String,
                          inputPlaceholder: String,
                          inputKeyboardType: UIKeyboardType,
                          actionHandler: @escaping (_ text: String?) -> Void)
}

protocol QRCodeServiceUseCaseProtocol {
    func getQRCodeData(_ str: String,
                       complitionHandler: @escaping (any DTODescription) -> Void,
                       errorHandler: () -> Void)
}

protocol ScannerBarcodeServiceUseCaseProtocol {
    func getBarcodeData(barcode: String,
                        completion: @escaping (any DTODescription) -> Void,
                        notFound: @escaping () -> Void)
}

protocol ScannerQrCodeStorageUseCaseProtocol {
    func create(dto: any DTODescription,
                complition: @escaping (Bool) -> Void)
}

protocol ScannerAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
    var remoteConfig: RemoteConfig? { get }
}

final class ScannerVM: NSObject,
                       ScannerViewModelProtocol,
                       AVCaptureMetadataOutputObjectsDelegate {
    
    enum FlashPhotoMode {
        case on
        case off
    }
    
    private enum AuthorizationStatus {
        case authorized
        case notAuthorized
    }
    
    private let captureSessionQueue: DispatchQueue =
        .init(label: "com.qrscanner.startrunning",
              qos: .background,
              attributes: .concurrent)
    
    private let requestAccessQueue: DispatchQueue =
        .init(label: "com.qrscanner.requestaccess",
              qos: .default,
              attributes: .concurrent)
    
    var playAnimationSpinner: ((Bool) -> Void)?
    var willResignActive: (() -> Void)?
    var flashMode: ((FlashPhotoMode) -> Void)?
    var delayAnimation: (() -> Void)?
   
    private var timer: Timer
    private var metadataOutput = AVCaptureMetadataOutput()
    private var captureSession: AVCaptureSession
    private var flashSettings: AVCapturePhotoSettings
    private let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice
        .default(for: .video)
    private var alertServise: ScannerAlertServiceUseCaseProtocol
    private var qrCodeService: QRCodeServiceUseCaseProtocol
    weak var coordinator: ScannerCoordinatorProtocol?
    private var barcodeService: ScannerBarcodeServiceUseCaseProtocol
    private var storage: ScannerQrCodeStorageUseCaseProtocol
    private let adaptyService: ScannerAdaptyServiceUseCaseProtocol
    
    init(coordinator: ScannerCoordinatorProtocol,
         alertServise: ScannerAlertServiceUseCaseProtocol,
         captureSession: AVCaptureSession,
         flashSettings: AVCapturePhotoSettings,
         qrCodeService: QRCodeServiceUseCaseProtocol,
         timer: Timer,
         barcodeService: ScannerBarcodeServiceUseCaseProtocol,
         storage: ScannerQrCodeStorageUseCaseProtocol,
         adaptyService: ScannerAdaptyServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.alertServise = alertServise
        self.captureSession = captureSession
        self.flashSettings = flashSettings
        self.qrCodeService = qrCodeService
        self.timer = timer
        self.barcodeService = barcodeService
        self.adaptyService = adaptyService
        self.storage = storage
    }
    
    //hand over previewLayer to VC
    func getCameraPreview() -> AVCaptureVideoPreviewLayer? {
        createVideoInput()
        createMetadataOutput()
        
        let previewLayer =
        AVCaptureVideoPreviewLayer(session: captureSession)
        
        return previewLayer
    }
    
    //check permission to show camera
    func checkForPermissions() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            startRunning()
            break
        case .notDetermined:
            /*
             Suspend the session queue to delay session
             until the access request has completed.
             */
            requestAccessQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video,
                                          completionHandler: { granted in
                if !granted {
                    self.showCameraErrorAlert()
                } else {
                    self.startRunning()
                }
                self.requestAccessQueue.resume()
            })
        default: showCameraErrorAlert()
        }
    }
    
    //start captureSession
    func startRunning() {
        captureSessionQueue.async { [captureSession] in
            captureSession.startRunning()
        }
    }
    
    //finally received the code
    private func receivedCode(qrcode: String) {
        self.qrCodeService.getQRCodeData(qrcode) { [weak self] dto in
            self?.saveToStorage(dto: dto)
        } errorHandler: { [weak self] in
            self?.startRunning()
            self?.showQRNoFoundAlert()
        }
    }
    
}

//Save to Storage
extension ScannerVM {
    
    func saveToStorage(dto: any DTODescription) {
        storage.create(dto: dto) { [weak self] completion in
            if completion {
                DispatchQueue.main.async {
                    self?.coordinator?.qrCodeDidFound(dto: dto)
                }
            } else {
                self?.showQRNoFoundAlert()
            }
        }
    }
    
}

//Connect lifecycles methods from VC
extension ScannerVM {
    
    @objc func viewWillResignActive() {
        toggleFlashPhotoMode(with: .off)
        willResignActive?()
        alertServise.hideAlert()
    }
    
    func viewDidDisappear() {
        guard let videoCaptureDevice else { return }
        if videoCaptureDevice.isTorchActive {
            toggleFlashPhotoMode(with: .off)
        }
        alertServise.hideAlert()
        playLoadSpiner(false)
        captureSession.stopRunning()
    }
    
    func viewWillAppear() {
        let not = NotificationCenter.default
        not.addObserver(self, selector: #selector(viewWillResignActive),
                        name: UIApplication.willResignActiveNotification,
                        object: nil)
        checkForPermissions()
    }
    
    func viewSafeAreaInsetsDidChange(screen: CGRect, scanRect: CGRect) {
        metadataOutput.rectOfInterest = metadataOutput
            .metadataOutputRectConverted(
                fromOutputRect: convertRectOfInterest(screenRect: screen,
                                                      rect: scanRect))
    }
    
}

//Buttons: [menu, flash]
extension ScannerVM {
    
    func menuButtonDidTap(sender: UIView) {
        coordinator?.showMenu(sender: sender, delegate: self)
    }
    
    func flashButtonDidTap() {
        guard let videoCaptureDevice else { return }
        
        if videoCaptureDevice.isTorchActive {
            toggleFlashPhotoMode(with: .off)
        } else {
            toggleFlashPhotoMode(with: .on)
        }
    }
    
}

//Setup camera: [MetadataOutput, VideoInput]
extension ScannerVM {
    
    private func createMetadataOutput() {
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self,
                                                      queue: DispatchQueue.main)
            
            // Check available metadata object types
            let availableTypes = metadataOutput.availableMetadataObjectTypes
            if availableTypes.contains(.qr) {
                metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .code128]
            } else {
                showCameraErrorAlert()
                return
            }
        } else {
            showCameraErrorAlert()
            return
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if showPaywall() {
            captureSession.stopRunning()
            return
        }
        
        playLoadSpiner(true)
        captureSession.stopRunning() // stop scanning after receiving metadata output
        
        if
            let metadataObject = metadataObjects.first {
            guard
                let readableObject =
                    metadataObject as? AVMetadataMachineReadableCodeObject
            else {
                showQRNoFoundAlert()
                return
            }
            guard
                let result = readableObject.stringValue
            else {
                showQRNoFoundAlert()
                return
            }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) //play vibrate
            if let _ = Int(result) {
                self.barcodeFound(text: result)
            } else {
                self.receivedCode(qrcode: result) // found qrcode
            }
        }
    }
    
    private func createVideoInput() {
        guard let videoCaptureDevice else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showQRNoFoundAlert()
            return
        }
        if (captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        } else {
            showCameraErrorAlert()
            return
        }
    }
    
}

// flashMode toggle
extension ScannerVM {
    
    private func toggleFlashPhotoMode(with state: FlashPhotoMode) {
        guard let videoCaptureDevice else { return }
        
        if videoCaptureDevice.hasTorch {
            do {
                try videoCaptureDevice.lockForConfiguration()
                
                if  state == .off {
                    videoCaptureDevice.torchMode = .off
                    flashMode?(.off)
                } else if state == .on {
                    videoCaptureDevice.torchMode = .on
                    flashMode?(.on)
                }
                
                videoCaptureDevice.unlockForConfiguration()

            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
}

//convertRectOfInterest
extension ScannerVM {
    
    func convertRectOfInterest(screenRect: CGRect, rect: CGRect) -> CGRect {
        let screenWidth = screenRect.width
        let screenHeight = screenRect.height
        let newX = rect.minX / screenWidth
        let newY = rect.minY  / screenHeight
        let newWidth =  rect.width / screenWidth
        let newHeight = rect.height / screenHeight
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
    
}

//showAlert
extension ScannerVM {
    
    private func showQRNoFoundAlert() {
        playLoadSpiner(false)
        DispatchQueue.main.async { [weak self] in
            self?.alertServise.showQRNoFoundAlert(title: "No Qr code found",
                                                  okTitle: "OK")
        }
        
    }
    
    private func showCameraErrorAlert() {
        DispatchQueue.main.async {
            self.alertServise.showCameraError(title: "Camera Error",
                                              message: "You need to allow your camera to perform scans.",
                                              goSettings: "Go to Settings") {
                if let appSettings =
                    URL(string: UIApplication.openSettingsURLString) {
                           UIApplication.shared.open(appSettings,
                                                     options: [:],
                                                     completionHandler: nil)
                    
                }
            }
        }
    }

}

//MenuDelegate
extension ScannerVM: ScannerMenuDelegate {
    
    func didSelect(action: ScannerMenuVC.Action) {
        switch action {
        case .gallery:
            coordinator?.showImagePicker(delegate: self)
            return
        case .barcode:
            self.alertServise.showBarcodeInput(title: "Set barcode",
                                               actionTitle: "Search",
                                               cancelTitle: "Cancel",
                                               inputPlaceholder: "8 or 13 digits",
                                               inputKeyboardType: .numberPad) {
                [weak self] text in
            
                guard self?.showPaywall() == false else { return }
                
                self?.barcodeFound(text: text)
            }
        }
    }

}

//Barcode found func
extension ScannerVM {
    
    func barcodeFound(text: String?) {
        guard let text, text.count == 8 || text.count == 13 else {
            showQRNoFoundAlert()
            return
        }
        playLoadSpiner(true)
        captureSession.stopRunning()
        barcodeService.getBarcodeData(barcode: text, completion: { [weak self] dto in
            self?.saveToStorage(dto: dto)
        }, notFound: { [weak self] in
            self?.showQRNoFoundAlert()
            self?.playLoadSpiner(false)
            self?.captureSession.startRunning()
        })
    }
    
}

//ImagePickerDelegate
extension ScannerVM: UIImagePickerControllerDelegate,
                     UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)

        if showPaywall() { return }
        
        if let image = info[.originalImage] as? UIImage {
            string(from: image)
        }
    }
    
}

//Convert QRCode from gallery to String
extension ScannerVM {
    
    func string(from image: UIImage) {
        playLoadSpiner(true)
        var qrAsString = ""
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: nil,
                                        options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let ciImage = CIImage(image: image),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else {
            showQRNoFoundAlert()
            return
        }
        
        for feature in features {
            guard let indeedMessageString = feature.messageString else {
                showQRNoFoundAlert()
                return
            }
            qrAsString += indeedMessageString
        }
        receivedCode(qrcode: qrAsString)
        return
    }
    
}

//Set Timer to animate Spinner
extension ScannerVM {
    
    private func setTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 ,
                                          repeats: true,
                                          block: { [weak self] timer in
            self?.delayAnimation?()
        })
    }
    
}

//Play load spiner animation
extension ScannerVM {
    
    private func playLoadSpiner(_ value: Bool) {
        
        playAnimationSpinner?(value)
        if value { setTimer() }
    }
    
}

//ShowPaywall func
extension ScannerVM {
    
    private func showPaywall() -> Bool {
        
        guard self.adaptyService.isPremium == false else { return false }
        
        guard
            let review = adaptyService.remoteConfig?.review,
            let supportTrial = adaptyService.remoteConfig?.supportTrial
        else {
            coordinator?.showPaywallReview()
            return true
        }
        
        if review {
            coordinator?.showPaywallReview()
        } else if review == false {
            if supportTrial {
                coordinator?.showPaywallProdTrial()
                return true
            } else {
                coordinator?.showPaywallProd()
                return true
            }
        }
        return true
    }
    
}
