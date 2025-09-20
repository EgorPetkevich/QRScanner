//
//  Coordinator.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit

class Coordinator {
    
    var onDidFinish: ((Coordinator) -> Void)?
    
    var children: [Coordinator] = []
    
    func start() -> UIViewController? {
        fatalError("method should be overriden")
    }
    
    func finish() {
        onDidFinish?(self)
    }
    
}

extension Coordinator: Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
