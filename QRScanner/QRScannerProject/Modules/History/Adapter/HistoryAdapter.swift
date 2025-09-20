//
//  HistoryAdapter.swift
//  QRScanner
//
//  Created by George Popkich on 2.08.24.
//

import UIKit
import Storage

final class HistoryAdapter: NSObject,
                            HistoryAdapterProtocol{
    
    var cellDidSelect: ((any DTODescription) -> Void)?
    var currentState: HistoryVM.ButtonTitleState = .select {
        didSet {
            selectedDTOList = [:]
            switch currentState {
            case .select:
                tableView.setEditing(false, animated: true)
            case .cancel:
                tableView.setEditing(true, animated: true)
            }
        }
    }

    private var dtoList: [any DTODescription] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var selectedDTOList: [String : any DTODescription] = [:]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.selectionFollowsFocus = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.tableHeaderView = nil
        tableView.tableHeaderView?.isHidden = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.cornerRadius = 16
        return tableView
    }()
    
    override init() {
        super.init()
        setupTableView()
    }
    
    func reloadDate(_ dtoList: [any DTODescription]) {
        self.dtoList = dtoList
    }
    
    func makeTableView() -> UITableView {
        self.tableView
    }
    
    func stateDidChange(state: HistoryVM.ButtonTitleState) {
        currentState = state
    }
    
    func selectedResult() -> [any DTODescription] {
        return Array(selectedDTOList.values)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhoneCell.self)
        tableView.register(LinkCell.self)
        tableView.register(TextCell.self)
        tableView.register(BarcodeCell.self)
    }
    
}

extension HistoryAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dtoList.count
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dto = dtoList[indexPath.row]
        
        switch dto {
        case is PhoneQrCodeDTO:
            let cell: PhoneCell = tableView.dequeue(at: indexPath)
            cell.setup(dto as! PhoneQrCodeDTO)
            return cell
        case is UrlQrCodeDTO:
            let cell: LinkCell = tableView.dequeue(at: indexPath)
            cell.setup(dto as! UrlQrCodeDTO)
            return cell
        case is TextQrCodeDTO:
            let cell: TextCell = tableView.dequeue(at: indexPath)
            cell.setup(dto as! TextQrCodeDTO)
            return cell
        case is BarcodeDTO:
            let cell: BarcodeCell = tableView.dequeue(at: indexPath)
            cell.setup(dto as! BarcodeDTO)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if currentState == .select {
            tableView.deselectRow(at: indexPath, animated: true)
            cellDidSelect?(dtoList[indexPath.row])
        } else {
            selectedDTOList[dtoList[indexPath.row].id] = dtoList[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, 
                   didDeselectRowAt indexPath: IndexPath) {
        if currentState == .cancel {
            selectedDTOList[dtoList[indexPath.row].id] = nil
        }
    }
}

extension HistoryAdapter: UITableViewDelegate {}


