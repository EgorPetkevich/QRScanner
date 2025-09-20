//
//  SettingsSection.swift
//  QRScanner
//
//  Created by George Popkich on 5.08.24.
//

import UIKit

final class SettingsSection {
    
    enum Settings: SettingsItem {
        case email
        case share
        case camera
        case terms
        case privacy
        
        var title: String {
            switch self {
            case .email: return "Contact us"
            case .share: return "Share App"
            case .camera: return "Camera access"
            case .terms: return "Terms of use"
            case .privacy: return "Privacy Policy"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .email: return .Settings.emailImage
            case .share: return .Settings.shareImage
            case .camera: return .Settings.cameraImage
            case .terms: return .Settings.fileImage
            case .privacy: return .Settings.privacyImage
            }
        }
    }
    
}
