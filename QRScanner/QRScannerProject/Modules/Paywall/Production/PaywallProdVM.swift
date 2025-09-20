//
//  PaywallProdVM.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import UIKit

protocol PaywallProdCoordinatorProtocol: AnyObject {
    func finish()
}

protocol PaywallProdAdaptyServiceUseCaseProtocol {
    var productWeaklyPrice: String? { get }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void)
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void)
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

protocol PaywallProdAlertServiceUseCaseProtocol {
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void)
}

final class PaywallProdVM: PaywallProdViewModelProtocol {
    
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
    private let adaptyService: PaywallProdAdaptyServiceUseCaseProtocol
    private let alertService: PaywallProdAlertServiceUseCaseProtocol
    
    private weak var coordinator: PaywallProdCoordinatorProtocol?
    
    init(coordinator: PaywallProdCoordinatorProtocol,
         adaptyService: PaywallProdAdaptyServiceUseCaseProtocol,
         alertService: PaywallProdAlertServiceUseCaseProtocol,
         timer: Timer) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
        self.alertService = alertService
        self.timer = timer
        
        bind()
    }
    
    private func bind() {
        price = adaptyService.productWeaklyPrice
        setTimer()
    }
    
    func viewDidLoad() {
        guard price != nil else {
            adaptyService.getProductPrice(type: .weakly) { [weak self] price in
                if let price {
                    self?.getPrice?(price)
                    self?.price = price
                }
            }
            return
        }
    }
    
    func viewDidAppear() {
        showClouseButton()
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
    
    private func showClouseButton() {
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(ParametersHelper.getTimer()),
                                          repeats: false,
                                          block: { [weak self] timer in
            self?.showCrossButton?()
        })
    }
    
    private func makePurchase() {
        adaptyService.makePurchase(type: .weakly) { [weak self] result in
            if result {
                self?.coordinator?.finish()
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

