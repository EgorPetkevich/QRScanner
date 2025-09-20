//
//  ScannerMenuAdapter.swift
//  QRScanner
//
//  Created by George Popkich on 29.07.24.
//

import UIKit

final class ScannerMenuAdapter: NSObject, ScannerMenuAdapterProtocol {
    
    private enum Const {
        static let rowHeight: CGFloat = 45.0
    }
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .appBackground
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Const.rowHeight
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    var contentHeight: CGFloat {
        return CGFloat(actions.count) * Const.rowHeight
    }
    
    private var actions: [ScannerMenuVC.Action]
    
    var didSelectAction: ((ScannerMenuVC.Action) -> Void)?
    
    init(actions: [ScannerMenuVC.Action]) {
        self.actions = actions
        super.init()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ScannerMenuCell.self)
    }
    
}

extension ScannerMenuAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScannerMenuCell = tableView.dequeue(at: indexPath)
        cell.setup(actions[indexPath.row])
        return cell
    }
    
}

extension ScannerMenuAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let action = actions[indexPath.row]
        didSelectAction?(action)
    }
    
}
