//
//  PaywallReviewVM.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import Foundation
import Adapty
import StoreKitTest

protocol PaywallReviewCoordinatorProtocol: AnyObject {
    func finish()
}

protocol PaywallReviewAdaptyServiceUseCaseProtocol {
    var trialPrice: String? { get }
    var weaklyPrice: String? { get }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void)
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void)
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

protocol PaywallReviewAlertServiceUseCaseProtocol {
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void)
}

final class PaywallReviewVM: PaywallReviewViewModelProtocol {
    
    private enum PaywallActions {
        case continueDidTap
        case restoreDidTap
    }
    
    var trialPrice: String?
    var weaklyPrice: String?
    
    var delayAnimation: (() -> Void)?
    var showCrossButton: (() -> Void)?
    var stopActivityAnimation: (() -> Void)?
    
    var isTrialIsOn: Bool? {
        didSet {
            setPrices()
        }
    }
    
    private var timer: Timer
    private let adaptyService: PaywallReviewAdaptyServiceUseCaseProtocol
    private let aletrService: PaywallReviewAlertServiceUseCaseProtocol
    private weak var coordinator: PaywallReviewCoordinatorProtocol?
    
    init(coordinator: PaywallReviewCoordinatorProtocol,
         adaptyService: PaywallReviewAdaptyServiceUseCaseProtocol,
         alertService: PaywallReviewAlertServiceUseCaseProtocol,
         timer: Timer) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
        self.aletrService = alertService
        self.timer = timer
        
        bind()
    }
    
    private func bind() {
        trialPrice = adaptyService.trialPrice
        weaklyPrice = adaptyService.weaklyPrice
        setTimer()
    }
    
    func viewDidLoad() {
        setPrices()
    }
    
    func viewDidAppear() {
        showCloseButton()
    }
    
    func crossButtonDidTap() {
        coordinator?.finish()
    }
    
    func privacyButtonDidTap() {
        if let url = URL(string: Constants.Settings.privacy) {
            UIApplication.shared.open(url)
        }
    }
    
    func restoreButtonDidTap() {
        adaptyService.restorePurchases { [weak self] completion in
            if completion {
                self?.coordinator?.finish()
            } else {
                self?.showErrorMessage(from: .restoreDidTap)
            }
        }
    }
    
    func termsButtonDidTap() {
        if let url = URL(string: Constants.Settings.terms) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setPrices() {
        guard let isTrialIsOn else { return }
        if isTrialIsOn {
            guard trialPrice != nil else {
                adaptyService.getProductPrice(type: .trial) {
                    [weak self] price in
                    if let price { self?.trialPrice = price }
                }
                return
            }
        } else {
            guard weaklyPrice != nil else {
                adaptyService.getProductPrice(type: .weakly) {
                    [weak self] price in
                    if let price { self?.weaklyPrice = price }
                }
                return
            }
        }
    }
    
    private func setTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 ,
                                          repeats: true,
                                          block: { [weak self] timer in
            self?.delayAnimation?()
        })
    }
    
    private func showCloseButton() {
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(ParametersHelper.getTimer()),
                                          repeats: false,
                                          block: { [weak self] timer in
            self?.showCrossButton?()
        })
    }
    
    
    func paywallButtonDidTap(_ withTrialIsOn: Bool) {
        self.isTrialIsOn = withTrialIsOn
        self.makePurchase(withTrialIsOn: withTrialIsOn)
    }
    
    private func showErrorMessage(from action: PaywallActions) {
        aletrService.showAlert(title: "Oops...",
                               message: "Something went wrong. Please try again",
                               cancelTitle: "Cancel", okTitle: "Try again")
        { [weak self] in
            switch action {
            case .continueDidTap:
                guard let isTrialIsOn = self?.isTrialIsOn else { return }
                self?.makePurchase(withTrialIsOn: isTrialIsOn)
            case .restoreDidTap:
                self?.restoreButtonDidTap()
            }
        }
    }
    
    private func makePurchase(withTrialIsOn: Bool) {
        if withTrialIsOn {
            adaptyService.makePurchase(type: .trial) { [weak self] result in
                if result {
                    self?.coordinator?.finish()
                } else {
                    self?.showErrorMessage(from: .continueDidTap)
                }
                self?.stopActivityAnimation?()
            }
        } else {
            adaptyService.makePurchase(type: .weakly) { [weak self] result in
                if result {
                    self?.coordinator?.finish()
                } else {
                    self?.showErrorMessage(from: .continueDidTap)
                }
                self?.stopActivityAnimation?()
            }
        }
    }
    
}

