//
//  AdaptyService.swift
//  QRScanner
//
//  Created by George Popkich on 6.08.24.
//

import Foundation
import Adapty
import StoreKit

final class AdaptyService {
    
    enum PurchaseType: Int {
        case trial
        case weakly
    }
    
    static let instansce = AdaptyService()
    
    var paywall: AdaptyPaywall?
    var remoteConfig: RemoteConfig?
    var products: [AdaptyPaywallProduct]? {
        didSet {
            updateProductPrice()
        }
    }
    //MARK: - Review
    var isPremium: Bool = true
    //
    var productTrialPrice: String?
    var productWeaklyPrice: String?
    
    private init() {}
    
    private func getPaywall() {
        Adapty.getPaywall(placementId: Constants.Adapty.placementId) {
            [weak self] result in
            do {
                print("[RESULT]: \(result)")
                let paywall = try result.get()
                print("[PAYWALL] \(paywall)")
                self?.paywall = paywall
            } catch {
                
            }
        }
    }
    
    func getRemoteConfig(completion: @escaping ((RemoteConfig?) -> Void)) {
        if let remoteConfig {
            completion(remoteConfig)
            getProducts()
        } else {
            if let paywall {
                guard let remoteConfigData =
                        paywall.remoteConfig?.jsonString.data(using: .utf8)
                else {
                    completion(nil)
                    return
                }
                do {
                    let remoteConfig =
                    try JSONDecoder().decode(RemoteConfig.self,
                                             from: remoteConfigData)
                    self.remoteConfig = remoteConfig
                    completion(remoteConfig)
                    getProducts()
                } catch {
                    completion(nil)
                }
            } else {
                Adapty.getPaywall(placementId: Constants.Adapty.placementId) {
                    [weak self] result in
                    do {
                        let paywall = try result.get()
                        self?.paywall = paywall
                        guard let remoteConfigData =
                                paywall.remoteConfig?.jsonString.data(using: .utf8)
                        else {
                            completion(nil)
                            return
                        }
                        let remoteConfig =
                        try JSONDecoder().decode(RemoteConfig.self,
                                                 from: remoteConfigData)
                        self?.remoteConfig = remoteConfig
                        self?.getProducts()
                        completion(remoteConfig)
                        
                    } catch {
                        completion(nil)
                        
                    }
                }
            }
        }
    }
    
    private func getProducts(_ completion: (([AdaptyPaywallProduct]?) -> Void)? = nil) {
        guard let paywall = paywall else {
            completion?(nil)
            print("[ERROR] Paywall is not available")
            return
        }
        Adapty.getPaywallProducts(paywall: paywall) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                completion?(products)
                print("[PRODUCTS]: \(products)")
            case .failure(let error):
                completion?(nil)
                print("[ERROR] Failed to get products: \(error)")
            }
        }
    }
    
    
    func checkStatus(complition: @escaping (_ isPremium: Bool?) -> Void) {
        //MARK: - Review
        complition(true)
        
//        Adapty.getProfile { result in
//            switch result {
//            case .success(let profile):
//                let isPremium = profile.accessLevels[
//                    Constants.Adapty.placementId]?.isActive ?? false
//                self.isPremium = isPremium
//                complition(isPremium)
//                print("[STATUS]: \(isPremium ? "premium" : "not premium")")
//            case .failure(let error):
//                print("[ERROR] Failed to get profile status: \(error)")
//                complition(nil)
//            }
//        }
    }
    
    func getProductPrice(type: PurchaseType,
                         completion: @escaping (String?) -> Void) {
        if let products = products {
            guard
                let selectedProd = getSelectedProd(type: type,
                                                   products: products)
            else {
                completion(nil)
                return
            }
            
            completion(selectedProd.skProduct.localizedCurrencyPrice)
            
        } else {
            getProducts { [weak self] products in
                guard
                    let products,
                    let selectedProd = self?.getSelectedProd(type: type,
                                                             products: products)
                else {
                    completion(nil)
                    return
                }
                
                completion(selectedProd.skProduct.localizedCurrencyPrice)
            }
            
        }
        
    }
    
    func updateProductPrice() {
        self.getProductPrice(type: .trial) { [weak self] price in
                self?.productTrialPrice = price
        }
        self.getProductPrice(type: .weakly) { [weak self] price in
                self?.productWeaklyPrice = price
        }
    }
    
    private func getSelectedProd(type: PurchaseType,
                                 products: [AdaptyPaywallProduct]
    ) -> AdaptyPaywallProduct? {
        let selectedProd = products[type.rawValue]
        return selectedProd
    }
    
    func makePurchase(type: PurchaseType,
                      completion: @escaping (Bool) -> Void) {
        if let products = products {
            guard
                let selectedProd = getSelectedProd(type: type,
                                                   products: products)
            else {
                completion(false)
                return
            }
            adaptyMakePurchase(selectedProd: selectedProd) { result in
                completion(result)
            }
        } else {
            getProducts { [weak self] products in
                guard
                    let products,
                    let selectedProd = self?.getSelectedProd(type: type,
                                                             products: products)
                else {
                    completion(false)
                    return
                }
                self?.adaptyMakePurchase(selectedProd: selectedProd) { result in
                    completion(result)
                }
                
            }
        }
    }
        
    private func adaptyMakePurchase(selectedProd: AdaptyPaywallProduct,
                                    completion: @escaping (Bool) -> Void) {
        Adapty.makePurchase(product: selectedProd) { result in
            switch result {
            case .success(let profile):
                print("[PURCHASE SUCCESS]: \(profile)")
                completion(true)
            case .failure(let error):
                print("[PURCHASE FAILURE]: \(error)")
                completion(false)
            }
        }
    }
    
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        Adapty.restorePurchases { [weak self] result in
            switch result {
            case .success(let profile):
                if profile.accessLevels[
                    Constants.Adapty.placementId]?.isActive ?? false {
                    self?.isPremium = true
                    print("[RESTORE SUCCESS]: Access restored")
                    completion(true)
                } else {
                    self?.isPremium = false
                    print("[RESTORE SUCCESS]: Access not restored")
                    completion(false)
                }
            case .failure(let error):
                print("[RESTORE FAILURE]: \(error)")
                completion(false)
            }
        }
    }

}
