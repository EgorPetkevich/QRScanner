//
//  HistoryVM.swift
//  QRScanner
//
//  Created by George Popkich on 20.07.24.
//

import UIKit
import Storage

protocol HistoryCoordinatorProtocol: AnyObject {
    func resultDidSelect(dto: any DTODescription)
    func presentShareSheet(content: [URL])
    func openScanner()
}

protocol HistoryAdapterProtocol {
    var cellDidSelect: ((any DTODescription) -> Void)? { get set }
    
    func reloadDate(_ dtoList: [any DTODescription])
    func makeTableView() -> UITableView
    func stateDidChange(state: HistoryVM.ButtonTitleState)
    func selectedResult() -> [any DTODescription]
}

protocol HistoryFRCServiceUseCaseProtocol {
    var fetchedDTOs: [any DTODescription] { get }
    var didChangeContent: (([any DTODescription]) -> Void)? { get set }
    func startHandle()
}

protocol HistoryQrCodeStorageUseCaseProtocol {
    func deleteSelected(dtos: [any DTODescription])
}

final class HistoryVM: HistoryViewModelProtocol {
    
    var currentState: ButtonTitleState = .select {
        didSet {
            buttonTitleState?(currentState.rawValue)
            buttonState?(currentState)
            adapter.stateDidChange(state: currentState)
        }
    }
    
    enum ButtonTitleState: String {
        case select = "Select"
        case cancel = "Cancel"
        
        mutating func toggle() {
               switch self {
               case .select:
                   self = .cancel
               case .cancel:
                   self = .select
               }
           }
    }
    
    enum QrCodeFilterType: CaseIterable {
        case qrcode
        case barcode
    }
    
    var buttonTitleState: ((String) -> Void)?
    var buttonState: ((ButtonTitleState) -> Void)?
    var showActionView: ((Bool) -> Void)?
    
    private var selectedFilter: QrCodeFilterType = .qrcode {
        didSet {
            adapter.reloadDate(filterResults())
        }
    }
    
    weak var coordinator: HistoryCoordinatorProtocol?
    
    private let adapter: HistoryAdapter
    private var frcService: HistoryFRCServiceUseCaseProtocol
    private var storage: HistoryQrCodeStorageUseCaseProtocol
    
    init(coordinator: HistoryCoordinatorProtocol,
         adapter: HistoryAdapter,
         frcService: HistoryFRCServiceUseCaseProtocol,
         storage: HistoryQrCodeStorageUseCaseProtocol) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.frcService = frcService
        self.storage = storage
        
        bind()
    }
    
    private func bind() {
        frcService.didChangeContent = { [weak self] dtoList in
            self?.adapter.reloadDate(self?.filterResults() ?? [])
            self?.showActionView?(dtoList.count == .zero)
        }
        adapter.cellDidSelect = { [weak self] dto in
            self?.coordinator?.resultDidSelect(dto: dto)
        }
    }
    
    func viewDidLoad() {
        frcService.startHandle()
        let dtos = filterResults()
        adapter.reloadDate(dtos)
    }
    
    func viewWillAppear() {
        let dtos = frcService.fetchedDTOs
        self.showActionView?(dtos.count == .zero)
    }
    
    func segmentControlDidChange(value: Int) {
        if let selectedType = QrCodeFilterType.allCases[safe: value] {
            selectedFilter = selectedType
        }
    }
    
    func selectButtonDidTap() {
        currentState.toggle()
    }
    
    func makeTableView() -> UITableView {
        return adapter.makeTableView()
    }
    
    func scanCodeButtonDidTap() {
        coordinator?.openScanner()
    }
    
    func deleteButtonDidTap() {
        storage.deleteSelected(dtos: adapter.selectedResult())
        currentState.toggle()
    }
    
    func exportButtonDidTap() {
        if !adapter.selectedResult().isEmpty {
            let exportContent = contentFilter(dtos: adapter.selectedResult())
            coordinator?.presentShareSheet(content: exportContent)
        }
        currentState.toggle()
    }
    
    private func contentFilter(dtos: [any DTODescription]) -> [URL] {
        var content = [URL]()
        for dto in dtos {
            if let phoneDTO = dto as? PhoneQrCodeDTO {
                if let url = URL(string: "tel://" + phoneDTO.phone) {
                    content.append(url)
                }
            }
            if let urlDTO = dto as? UrlQrCodeDTO {
                if let url = URL(string: urlDTO.strUrl) {
                    content.append(url)
                }
            }
            if let textDTO = dto as? TextQrCodeDTO {
                if let url = URL(string: textDTO.strUrl ?? textDTO.text) {
                    content.append(url)
                }
            }
            if let barcodeDTO = dto as? BarcodeDTO {
                if let url = URL(string: barcodeDTO.strUrl) {
                    content.append(url)
                }
            }
        }
        return content
    }
    
    private func filterResults() -> [any DTODescription] {
        return  frcService.fetchedDTOs.filter { dto in
            switch selectedFilter {
            case .qrcode:
                return dto is TextQrCodeDTO || dto is PhoneQrCodeDTO || dto is UrlQrCodeDTO
            case .barcode:
                return dto is BarcodeDTO
            }
        }
    }
    
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
