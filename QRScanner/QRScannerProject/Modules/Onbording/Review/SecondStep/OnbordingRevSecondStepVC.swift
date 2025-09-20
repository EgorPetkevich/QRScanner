//
//  OnbordingRevSecondStepVC.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit
import SnapKit
import Lottie

protocol OnbordingRevSecondStepViewModelProtocol {
    var delayAnimation: (() -> Void)? { get set }
    func viewDidLoad()
    func continueButtonDidTap()
}

final class OnbordingRevSecondStepVC: UIViewController {
    
    private lazy var secondStepImageView: UIImageView =
    UIImageView(
        image: .Onbording.secondStepImage
    )
    
    private lazy var contentView: UIView = .contentView()
    private lazy var gradientView: UIView = .gradientView()
    private lazy var titleLabel: UILabel = .title("Fast and Simple<br>Scanning")
    private lazy var subTitleLabel: UILabel =
        .reviewSubtitle("Experience quick and seamless QR code scanning<br>that works flawlessly every time.")
    
    private lazy var continueButton =
    ContinueButton(
        target: self,
        action: #selector(continueButtonDidTap),
        titleText: "<span style=\"font-weight: 700;\">Continue</span>"
    )
    
    private lazy var animationSubView: LottieAnimationView =
        .Onbording
        .secondStepAnimation
   
    private var viewModel: OnbordingRevSecondStepViewModelProtocol
    
    init(viewModel: OnbordingRevSecondStepViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setup()
        setupConstrains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBounceAnimation()
    }
    
    private func bind() {
        viewModel.delayAnimation = { [weak animationSubView] in
            animationSubView?.play()
        }
    }
    
    private func setup() {
        view.backgroundColor = .appBackground
        continueButton.layer.cornerRadius = 32.0
        continueButton.layer.masksToBounds = true
        animationSubView.contentMode = .scaleAspectFit
        
        view.addSubview(secondStepImageView)
        view.addSubview(contentView)
        
        secondStepImageView.addSubview(animationSubView)
        contentView.addSubview(gradientView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(continueButton)
    }
    
    private func setupConstrains() {
        secondStepImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70.18)
            make.left.equalToSuperview().offset(39.18)
            make.right.equalToSuperview().inset(39.18)
            make.bottom.equalToSuperview().inset(142.16)
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(343.0)
        }
        
        continueButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(55.0)
        }
        
        animationSubView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15.0)
            make.right.equalToSuperview().inset(15.0)
            make.verticalEdges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(116.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-16.0)
            make.height.equalTo(86.0)
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(continueButton.snp.top).offset(-44.0)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    @objc func continueButtonDidTap() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        continueButton.setIsEnable(false)
        continueButton.setArrowImageViewIsHidden(true)
        
        DispatchQueue
            .main
            .async { [weak continueButton] in
                continueButton?.stopAnimating()
                continueButton?.setArrowImageViewIsHidden(false)
                continueButton?.setIsEnable(true)
            }
        self.viewModel.continueButtonDidTap()
    }
    
    private func startBounceAnimation() {
        continueButton.bounceAnimation()
    }
    
}


