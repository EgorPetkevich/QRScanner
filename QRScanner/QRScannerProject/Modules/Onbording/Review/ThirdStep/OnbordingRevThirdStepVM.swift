//
//  OnbordingRevThirdStepVM.swift
//  QRScanner
//
//  Created by George Popkich on 19.07.24.
//

import Foundation

protocol OnbordingRevThirdStepCoordinatorProtocol: AnyObject {
    func nextStep()
}

final class OnbordingRevThirdStepVM: OnbordingRevThirdStepViewModelProtocol {
    
    var delayAnimation: (() -> Void)?
    
    private var timer: Timer?
    
    private weak var coordinator: OnbordingRevThirdStepCoordinatorProtocol?
    
    init(coordinator: OnbordingRevThirdStepCoordinatorProtocol,
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
        ParametersHelper.set(.reviewWasShown, value: true)
        coordinator?.nextStep()
    }
    
}
