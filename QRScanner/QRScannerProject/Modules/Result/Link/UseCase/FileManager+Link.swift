//
//  FileManager+Link.swift
//  QRScanner
//
//  Created by George Popkich on 1.08.24.
//

import UIKit

struct LinkResultFileManagerServiceUseCase:
    LinkResultFileManagerServiceUseCaseProtocol {
    
    private let fileManager: FileManagerService
    
    init(fileManager: FileManagerService) {
        self.fileManager = fileManager
    }
    
    func read(with path: String) -> UIImage? {
        fileManager.read(directory: .qrCodeImages, with: path)
    }
    
}
