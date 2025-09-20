//
//  SettingsAdapter.swift
//  QRScanner
//
//  Created by George Popkich on 4.08.24.
//

import UIKit

final class SettingsAdapter: NSObject, SettingsAdapterProtocol {
    
    private enum Const {
        static let rowHeight: CGFloat = 64.0
    }
    
    var cellDidSelect: ((SettingsSection.Settings) -> Void)?
    
    private var cells: [SettingsSection.Settings] = {
        return [.email, .share, .camera, .terms, .privacy]
    }()
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Const.rowHeight
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .appGrey
        tableView.cornerRadius = 24.0
        return tableView
    }()
    
    override init() {
        super.init()
        setupTableView()
    }
    
    func makeTableView() -> UITableView {
        self.tableView
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self)
    }
    
}

extension SettingsAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeue(at: indexPath)
        cell.setup(cells[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = cells[indexPath.row]
        cellDidSelect?(cell)
    }
    
}

extension SettingsAdapter: UITableViewDelegate {}
