//
//  PaywallProdVC.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit
import SnapKit
import Lottie

protocol PaywallProdViewModelProtocol {
    var delayAnimation: (() -> Void)? { get set }
    var showCrossButton: (() -> Void)? { get set }
    var getPrice: ((String) -> Void)? { get set }
    var price: String? { get }
    var stopActivityAnimation: (() -> Void)? { get set }
  
    func viewDidLoad()
    func viewDidAppear()
    func crossButtonDidTap()
    func continueButtonDidTap()
    func privacyButtonDidTap()
    func restoreButtonDidTap()
    func termsButtonDidTap()
}

final class PaywallProdVC: UIViewController {
    
    private var switchIsOn: Bool?
    
    private lazy var animationView: UIView = UIView()
    private lazy var pageControl: UIPageControl =
        .onbordingPageControl(numOfPages: Onbording.numOfPages(),
                              currentPage: Onbording.step(.paywall))
    
    private lazy var contentView: UIView = .contentView()
    private lazy var gradientView: UIView = .gradientView()
    private lazy var titleLabel: UILabel = .title("Full access<br>to all features")
    private lazy var subTitleLabel: UILabel = .paywallProdSubtitle("Start to continue QR code Scanner App with no limits\njust for \(viewModel.price ?? "7,99 $")/week.")
    private lazy var privacyButton: UIButton =
        .underContinueButton(title: "Privacy")
        .addAction(self,action: #selector(privacyButtonDidTap))
    private lazy var restoreButton: UIButton =
        .underContinueButton(title: "Restore")
        .addAction(self, action: #selector(restoreButtonDidTap))
    private lazy var termsButton: UIButton =
        .underContinueButton(title: "Terms")
        .addAction(self, action: #selector(termsButtonDidTap))
    
    private lazy var continueButton =
    ContinueButton(
        target: self,
        action: #selector(continueButtonDidTap),
        titleText: "<span style=\"font-weight: 700;\">Continue</span>"
    )
    
    private lazy var crossButton: UIButton =
        .crossButton()
        .addAction(self, action: #selector(crossButtonDidTap))
    
    private lazy var animationSubView: LottieAnimationView =
        .Onbording
        .paywallAnimation
   
    
    private var viewModel: PaywallProdViewModelProtocol
    
    init(viewModel: PaywallProdViewModelProtocol,
         pageControlIsHiden: Bool) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.pageControl.isHidden = pageControlIsHiden
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
        viewModel.viewDidAppear()
        startBounceAnimation()
    }
    
    private func bind() {
        viewModel.delayAnimation = { [weak animationSubView] in
            animationSubView?.play()
        }
        viewModel.showCrossButton = { [weak crossButton] in
            crossButton?.isHidden = false
        }
        viewModel.getPrice = { [weak self] price in
            self?.subTitleLabel.text = "Start to continue QR code Scanner App with no\nlimits just for \(price)/week."
        }
        viewModel.stopActivityAnimation = { [weak continueButton] in
            continueButton?.stopAnimating()
            continueButton?.setArrowImageViewIsHidden(false)
            continueButton?.setIsEnable(true)
        }
    }
    
    private func setup() {
        view.backgroundColor = .appBackground
        continueButton.cornerRadius = 32.0
        continueButton.layer.masksToBounds = true
        animationSubView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        view.addSubview(contentView)
        view.addSubview(crossButton)
        crossButton.isHidden = true
        
        animationView.addSubview(animationSubView)
        
        animationView.addSubview(gradientView)
        animationView.layer.zPosition = .greatestFiniteMagnitude
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(continueButton)
        contentView.addSubview(privacyButton)
        contentView.addSubview(restoreButton)
        contentView.addSubview(termsButton)
        contentView.addSubview(pageControl)
    }
    
    private func setupConstrains() {
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(164)
            make.horizontalEdges.equalToSuperview()
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
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(357.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(116.0)
        }
        
        privacyButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(34.0)
            make.top.equalTo(continueButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(continueButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        termsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(34.0)
            make.top.equalTo(continueButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(86.0)
            make.left.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().inset(16.0)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.horizontalEdges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints({ make in
            make.bottom.equalTo(continueButton.snp.top).inset(-13.0)
            make.centerX.equalToSuperview()
        })
        
        crossButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(69.0)
            make.left.equalTo(16.0)
            make.size.equalTo(20.0)
        }
        
    }
    
    @objc func continueButtonDidTap() {
        continueButton.setIsEnable(false)
        continueButton.setArrowImageViewIsHidden(true)
        continueButton.startActivityIndicatorAnimating()
        self.viewModel.continueButtonDidTap()
    }
    
    @objc func crossButtonDidTap() {
        viewModel.crossButtonDidTap()
    }
    
    @objc private func privacyButtonDidTap() {
        viewModel.privacyButtonDidTap()
    }
    
    @objc private func restoreButtonDidTap() {
        viewModel.restoreButtonDidTap()
    }
    
    @objc private func termsButtonDidTap() {
        viewModel.termsButtonDidTap()
    }
    
    private func startBounceAnimation() {
        continueButton.bounceAnimation()
    }
    
}


