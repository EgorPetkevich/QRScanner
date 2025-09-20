//
//  LaunchCoordanator.swift
//  QRScanner
//
//  Created by George Popkich on 5.08.24.
//

import UIKit

final class LaunchCoordanator: Coordinator {
    
    override func start() -> UIViewController {
        let vc = LaunchVC(coordinator: self)
        return vc
    }
    
}
