//
//  OnbordingRevFirstStepVM.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import Foundation

protocol OnbordingRevFirstStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnbordingRevFirstStepVM: OnbordingRevFirstStepViewModelProtocol {
    
    var delayAnimation: (() -> Void)?
    
    private var timer: Timer?
    
    private weak var coordinator: OnbordingRevFirstStepCoordinatorProtocol?
    
    init(coordinator: OnbordingRevFirstStepCoordinatorProtocol,
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
    
    func continueButtonDidTap() {
        coordinator?.nextStep()
    }
    
}

