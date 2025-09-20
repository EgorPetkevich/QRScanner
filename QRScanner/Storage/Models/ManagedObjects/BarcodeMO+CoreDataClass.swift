//
//  BarcodeMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData

@objc(BarcodeMO)
public class BarcodeMO: BaseQrCodeMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return BarcodeDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescription) {
        guard let barcodeDTO = dto as? BarcodeDTO else {
            print("[applyMOtoDTO]", "\(Self.self) apply failed: dto type: \(type(of: dto))")
            return
        }
        super.apply(dto: dto)
        self.barcode = barcodeDTO.barcode
        self.strUrl = barcodeDTO.strUrl
    }
    
}
