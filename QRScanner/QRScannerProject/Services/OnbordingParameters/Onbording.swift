//
//  Onbording.swift
//  QRScanner
//
//  Created by George Popkich on 17.07.24.
//

import Foundation

class Onbording {
    
    enum Options {
        case review
        case production
        case reviewWithTrial
        case productionWithTrial
    }
    
    enum ProductionOnbordingPage {
        case first
        case second
        case third
        case paywall
    }
    
    static func numOfPages() -> Int {
        return 5
    }
    
    static func step(_ page: ProductionOnbordingPage) -> Int {
        switch page {
        case .first:
            return 0
        case .second:
            return 1
        case .third:
            return 2
        case .paywall:
            return 3
        }
    }
    
}
