//
//  PaywallProdTrialVM.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

protocol PaywallProdTrialCoordinatorProtocol: AnyObject {
    func nextStep()
    func finish()
}

protocol PaywallProdTrialAdaptyServiceUseCaseProtocol {
    var productTrialPrice: String? { get }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void)
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void)
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

protocol PaywallProdTrialAlertServiceUseCaseProtocol {
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void)
}

final class PaywallProdTrialVM: PaywallProdTrialViewModelProtocol {
    
    private enum PaywallActions {
        case continueDidTap
        case restoreDidTap
    }
    
    var price: String?
    
    var getPrice: ((String) -> Void)?
    var delayAnimation: (() -> Void)?
    var showCrossButton: (() -> Void)?
    var stopActivityAnimation: (() -> Void)?
    
    private var timer: Timer?
    private let adaptyService: PaywallProdTrialAdaptyServiceUseCaseProtocol
    private let alertService: PaywallProdTrialAlertServiceUseCaseProtocol
    
    private weak var coordinator: PaywallProdTrialCoordinatorProtocol?
    
    init(coordinator: PaywallProdTrialCoordinatorProtocol,
         adaptyService: PaywallProdTrialAdaptyServiceUseCaseProtocol,
         alertService: PaywallProdTrialAlertServiceUseCaseProtocol,
         timer: Timer) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
        self.alertService = alertService
        self.timer = timer
        
        bind()
    }
    
    private func bind() {
        price = adaptyService.productTrialPrice
        setTimer()
    }
    
    func viewDidLoad() {
        guard price != nil else {
            adaptyService.getProductPrice(type: .trial) { [weak self] price in
                if let price {
                    self?.getPrice?(price)
                    self?.price = price
                }
            }
            return
        }
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
    
    private func setTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 ,
                                          repeats: true,
                                          block: { [weak self] timer in
            self?.delayAnimation?()
        })
    }
    
    func continueButtonDidTap() {
        makePurchase()
    }
    
    private func showCloseButton() {
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(ParametersHelper.getTimer()),
                                          repeats: false,
                                          block: { [weak self] timer in
            self?.showCrossButton?()
        })
    }
    
    private func makePurchase() {
        adaptyService.makePurchase(type: .trial) { [weak self] result in
            if result {
                self?.coordinator?.nextStep()
            } else {
                self?.showErrorMessage(from: .continueDidTap)
            }
            self?.stopActivityAnimation?()
        }
    }
    
    private func showErrorMessage(from action: PaywallActions) {
        alertService.showAlert(title: "Oops...",
                               message: "Something went wrong. Please try again",
                               cancelTitle: "Cancel", okTitle: "Try again")
        { [weak self] in
            switch action {
            case .continueDidTap:
                self?.makePurchase()
            case .restoreDidTap:
                self?.restoreButtonDidTap()
            }
        }
    }
    
    
}


