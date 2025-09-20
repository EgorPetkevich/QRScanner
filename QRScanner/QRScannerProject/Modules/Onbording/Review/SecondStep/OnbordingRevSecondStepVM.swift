//
//  OnbordingRevSecondStepVM.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import Foundation
import StoreKit

protocol OnbordingRevSecondStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnbordingRevSecondStepVM: OnbordingRevSecondStepViewModelProtocol {
    
    var delayAnimation: (() -> Void)?
    
    private var timer: Timer?
    
    private weak var coordinator: OnbordingRevSecondStepCoordinatorProtocol?
    
    init(coordinator: OnbordingRevSecondStepCoordinatorProtocol,
         timer: Timer) {
        self.coordinator = coordinator
        self.timer = timer
        
        bind()
    }
    
    private func bind() {
        setTimer()
    }
    
    
    private func setTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 ,
                                          repeats: true,
                                          block: { [weak self] timer in
            self?.delayAnimation?()
        })
    }
    
    func viewDidLoad() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    func continueButtonDidTap() {
        coordinator?.nextStep()
    }
    
}


