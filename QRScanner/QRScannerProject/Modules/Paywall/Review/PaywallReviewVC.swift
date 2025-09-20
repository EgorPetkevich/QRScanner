//
//  PaywallReviewVC.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit
import SnapKit
import Lottie

protocol PaywallReviewViewModelProtocol {
    var trialPrice: String? { get }
    var weaklyPrice: String? { get }
    
    var delayAnimation: (() -> Void)? { get set }
    var showCrossButton: (() -> Void)? { get set }
    var stopActivityAnimation: (() -> Void)? { get set }
    
    func viewDidLoad()
    func viewDidAppear()
    func crossButtonDidTap()
    func privacyButtonDidTap()
    func restoreButtonDidTap()
    func termsButtonDidTap()
    func paywallButtonDidTap(_ withTrialIsOn: Bool)
}

final class PaywallReviewVC: UIViewController {
    
    private var withTrialIsOn: Bool = false
    private var trialPrice: String
    private var weaklyPrice: String
    
    private lazy var animationView: UIView = UIView()
    private lazy var contentView: UIView = .contentView()
    private lazy var gradientView: UIView = .gradientView()
    private lazy var switchView: UIView = PaywallSwitch(target: self, action: #selector(swithValueDidChange))
    private lazy var titleLabel: UILabel = 
        .title("Full access<br>to all features")
    private lazy var subTitleLabel: UILabel =
        .paywallRevSubtitle("Start QR code Scanner App finder app\nwith no limits just for \(weaklyPrice)/week.")
    private lazy var privacyButton: UIButton =
        .underContinueButton(title: "Privacy")
        .addAction(self,action: #selector(privacyButtonDidTap))
    private lazy var restoreButton: UIButton =
        .underContinueButton(title: "Restore")
        .addAction(self, action: #selector(restoreButtonDidTap))
    private lazy var termsButton: UIButton =
        .underContinueButton(title: "Terms")
        .addAction(self, action: #selector(termsButtonDidTap))
    
    private lazy var paywallButton =
    PaywallButton(
        target: self,
        action: #selector(paywallButtonDidTap),
        titleText: "Subscribe for \(weaklyPrice)/week"
    )
    
    private lazy var crossButton: UIButton =
        .crossButton()
        .addAction(self, action: #selector(crossButtonDidTap))
    
    private lazy var animationSubView: LottieAnimationView =
        .Onbording
        .paywallAnimation
   
    
    private var viewModel: PaywallReviewViewModelProtocol
    
    init(viewModel: PaywallReviewViewModelProtocol) {
        self.viewModel = viewModel
        self.trialPrice = viewModel.trialPrice ?? "7,99 $"
        self.weaklyPrice = viewModel.weaklyPrice ?? "7,99 $"
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
        viewModel.stopActivityAnimation = { [weak paywallButton] in
            paywallButton?.stopAnimating()
            paywallButton?.setArrowImageViewIsHidden(false)
            paywallButton?.setIsEnable(true)
        }
    }
    
    private func setup() {
        view.backgroundColor = .appBackground
        paywallButton.cornerRadius = 32.0
        paywallButton.layer.masksToBounds = true
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
        contentView.addSubview(paywallButton)
        contentView.addSubview(privacyButton)
        contentView.addSubview(restoreButton)
        contentView.addSubview(termsButton)
        switchView.layer.cornerRadius = 32.0
        switchView.layer.masksToBounds = true
        contentView.addSubview(switchView)
        
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
        
        paywallButton.snp.makeConstraints { make in
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
            make.top.equalTo(paywallButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(paywallButton.snp.bottom).offset(4.0)
            make.height.equalTo(17.0)
        }
        
        termsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(34.0)
            make.top.equalTo(paywallButton.snp.bottom).offset(4.0)
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
        
        switchView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(paywallButton)
            make.height.equalTo(paywallButton.snp.height)
            make.bottom.equalTo(paywallButton.snp.top).inset(-8.0)
        }
        
        crossButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(69.0)
            make.left.equalTo(16.0)
            make.size.equalTo(20.0)
        }
        
    }
    
    private func setupOnSwitch() {
        DispatchQueue.main.async { [weak self] in
            self?.changeConstraints()
            if self?.withTrialIsOn == true {
                
                self?.subTitleLabel.text = "Start a 3-day free trial of QR code Scanner App\nwith no limits just for \(self?.trialPrice ?? "")/week."
                self?.paywallButton.titleLabel.text = "3-day Free Trial then \(self?.trialPrice ?? "")/week"
                
            } else {
                self?.subTitleLabel.text = "Start QR code Scanner App finder app\nwith no limits just for \(self?.weaklyPrice ?? "")/week."
                self?.paywallButton.titleLabel.text = "Subscribe for \(self?.weaklyPrice ?? "")/week"
            }
        }
    }
    
    @objc func paywallButtonDidTap() {
        paywallButton.setIsEnable(false)
        paywallButton.setArrowImageViewIsHidden(true)
        paywallButton.startActivityIndicatorAnimating()
        self.viewModel.paywallButtonDidTap(self.withTrialIsOn)
    }
    
    @objc func swithValueDidChange(_ sender: UISwitch) {
        print(#function)
        withTrialIsOn = sender.isOn
        setupOnSwitch()
        print(sender.isOn)
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
    
    private func changeConstraints() {
        paywallButton.titleLabel.snp.removeConstraints()
        paywallButton.subTitleLabel.snp.removeConstraints()
        
        if withTrialIsOn {
            paywallButton.titleLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(57.5)
                make.top.equalToSuperview().inset(10)
                
            }
            paywallButton.subTitleLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(57.5)
                make.bottom.equalToSuperview().inset(10)
                
            }
        } else {
            paywallButton.titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(10)
                
            }
            
            paywallButton.subTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
                
            }
            
        }
    }
    
    private func startBounceAnimation() {
        paywallButton.bounceAnimation()
    }
    
}


