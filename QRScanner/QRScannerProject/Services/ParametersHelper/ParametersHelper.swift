//
//  ParametersHelper.swift
//  QRScanner
//
//  Created by George Popkich on 1.08.24.
//

import Foundation

final class ParametersHelper {
    
    enum ParametersKey: String {
        case createQrCodeImagesDirectory
        case reviewWasShown
        case prodWasShow
        case timer
    }
    
    private static var ud: UserDefaults = .standard
    
    private init() {}
    
    static func set(_ key: ParametersKey, value: Bool) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    static func get(_ key: ParametersKey) -> Bool {
        ud.bool(forKey: key.rawValue)
    }
    
    static func setTimer(_ timer: Int) {
        ud.set(timer, forKey: ParametersKey.timer.rawValue)
    }
    
    static func getTimer() -> Int {
        if let value = ud.value(forKey: ParametersKey.timer.rawValue) as? Int {
            return value
        }
        return 0
    }
    
}
