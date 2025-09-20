//
//  ScanerVC.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import AVFoundation
import Lottie

protocol ScannerViewModelProtocol {
    var flashMode: ((ScannerVM.FlashPhotoMode) -> Void)? { get set }
    var willResignActive: (() -> Void)? { get set }
    var playAnimationSpinner: ((Bool) -> Void)? { get set }
    var delayAnimation: (() -> Void)? { get set }
    
    func getCameraPreview() -> AVCaptureVideoPreviewLayer?
    func flashButtonDidTap()
    func startRunning()
    func viewDidDisappear()
    func viewWillAppear()
    func menuButtonDidTap(sender: UIView)
    func viewSafeAreaInsetsDidChange(screen: CGRect, scanRect: CGRect)
}

final class ScannerVC: UIViewController {
    
    private var cameraPreview: AVCaptureVideoPreviewLayer?
    private var flashMode: ScannerVM.FlashPhotoMode = .off
    
    private lazy var scanerView: UIView = UIView()
    private lazy var scanerBackgroundView: UIView = .scanerViewBackground()
    private lazy var frameScanerImageView = UIImageView(image: .Scanner.frameImage)
    private lazy var qrCodeLabel: UILabel = .mainTitleLabel("QR code")
    private lazy var lightLabel: UILabel = .lightLabel()
    private lazy var scanerInfoLabel: UILabel = .scanerInfoLabel()
    private lazy var animationSubView: LottieAnimationView =
        .Scanner
        .spinnerAnimation
    private lazy var animationBackgroundView: UIView =
        .spinnerAnimationBackgroundView()
    private lazy var menuButton: UIButton =
        .menuButton()
        .addAction(self, action: #selector(menuButtonDidTap))
    private lazy var lightButton: UIButton =
        .lightButton()
        .addAction(self, action: #selector(lightButtonDidTap))
    
    
    private var viewModel: ScannerViewModelProtocol
    
    init(viewModel: ScannerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraPreview = viewModel.getCameraPreview()
      
        setupLayer()
        setupUI()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        viewModel.viewSafeAreaInsetsDidChange(
            screen: self.scanerBackgroundView.frame,
            scanRect: frameScanerImageView.frame)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
        changeLightButtonState()
    }
    
    private func bind() {
        viewModel.flashMode = { [weak self] flashMode in
            self?.flashMode = flashMode
        }
        viewModel.willResignActive = { [weak self]  in
            self?.changeLightButtonState()
        }
        viewModel.playAnimationSpinner = { [weak self] value in
            self?.playAnimationSpinner(value)
        }
        viewModel.delayAnimation = { [weak self] in
            self?.animationSubView.play()
        }
  
    }
    
    private func setupTabBarItem() {
        self.tabBarItem.isEnabled = false
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        view.addSubview(menuButton)
        view.addSubview(qrCodeLabel)
        view.addSubview(scanerView)
        
        scanerView.addSubview(scanerBackgroundView)
        setupscanerBackgroundLayer()
        scanerBackgroundView.addSubview(frameScanerImageView)
        scanerBackgroundView.addSubview(lightButton)
        scanerBackgroundView.addSubview(lightLabel)
        scanerBackgroundView.addSubview(scanerInfoLabel)
        
        animationBackgroundView.addSubview(animationSubView)
        animationBackgroundView.isHidden = true
        animationBackgroundView.frame = UIScreen.main.bounds
        animationBackgroundView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        tabBarController?.view.addSubview(animationBackgroundView)
    }
    
    private func setupscanerBackgroundLayer() {
        scanerBackgroundView.frame = scanerView.frame.insetBy(dx: 0.0,
                                                              dy: 110)
        frameScanerImageView.center = CGPointMake(
            scanerBackgroundView.frame.size.width / 2 ,
            scanerBackgroundView.frame.size.height / 2 )
        
        let path = UIBezierPath(rect: scanerBackgroundView.bounds)
        
        let pathWithRAdius = UIBezierPath(
            roundedRect: frameScanerImageView.frame.insetBy(dx: 8.0,
                                                            dy: 8.0),
            cornerRadius: 15)
        
        path.append(pathWithRAdius)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        
        scanerBackgroundView.layer.mask = mask
    }
    
    private func setupLayer() {
        scanerView.frame = view.frame
        cameraPreview?.frame = self.scanerView.layer.bounds
        cameraPreview?.videoGravity = .resizeAspectFill
        scanerView.layer.bounds = self.view.layer.bounds
        scanerView.layer.addSublayer(cameraPreview ?? AVCaptureVideoPreviewLayer())
    }
    
    private func setupConstrains() {
        qrCodeLabel.snp.makeConstraints { make in
            make.height.equalTo(33.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(scanerView.snp.top).inset(-8.0)
        }
        
        scanerBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        scanerInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(69.0)
        }
        
        menuButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(13.0)
            make.bottom.equalTo(scanerView.snp.top).inset(-8.0)
        }
        
        scanerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(111.0)
            make.bottom.equalToSuperview().inset(101.0)
        }
        
        lightButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16.0)
            make.height.width.equalTo(44.0)
        }
        lightButton.cornerRadius = 12.0
        
        lightLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.width.equalTo(lightButton.snp.width)
            make.top.equalTo(lightButton.snp.bottom).offset(4.0)
            make.height.equalTo(18.0)
        }
        
        animationSubView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc private func menuButtonDidTap() {
        viewModel.menuButtonDidTap(sender: menuButton)
    }
    
    @objc private func lightButtonDidTap() {
        viewModel.flashButtonDidTap()
        changeLightButtonState()
    }
    
    private func changeLightButtonState() {
        DispatchQueue.main.async { [weak self] in
            if self?.flashMode == .on {
                self?.lightButton.setImage(.Scanner.lightOnImage, for: .normal)
            } else {
                
                self?.lightButton.setImage(.Scanner.lightOffImage, for: .normal)
            }
        }
    }
    
    private func playAnimationSpinner(_ value: Bool) {
        DispatchQueue.main.async { [weak self] in
            if value {
                self?.animationBackgroundView.isHidden = false
                self?.animationSubView.play()
            } else {
                self?.animationBackgroundView.isHidden = true
                self?.animationSubView.stop()
            }
        }
    }

}
