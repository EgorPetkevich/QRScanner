//
//  TabelView+Register.swift
//  QRScanner
//
//  Created by George Popkich on 29.07.24.
//

import UIKit

extension UITableView {
    
    func dequeue<CellType: UITableViewCell>(at indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withIdentifier:"\(CellType.self)",
                                        for: indexPath) as! CellType
    }
    
    func register<CellType: UITableViewCell>(_ type: CellType.Type) {
        register(type.self, forCellReuseIdentifier: "\(type.self)")
    }
    
}
