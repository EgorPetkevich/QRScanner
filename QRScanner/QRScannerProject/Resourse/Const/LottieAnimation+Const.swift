//
//  LottieAnimation+Const.swift
//  QRScanner
//
//  Created by George Popkich on 16.07.24.
//

import Lottie

extension LottieAnimationView {
    
    enum Onbording {
        static var firstStepAnimation = LottieAnimationView(name: "FirstStepGif")
        static var secondStepAnimation = LottieAnimationView(name: "SecondStepGif")
        static var thirdStepAnimation = LottieAnimationView(name: "FirstStepGif")
        static var paywallAnimation = LottieAnimationView(name: "PaywallGif")
    }
    
    enum Scanner {
        static var spinnerAnimation = LottieAnimationView(name: "getSolution")
    }
    
}
