//
//  UrlQrCodeMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData

@objc(UrlQrCodeMO)
public class UrlQrCodeMO: BaseQrCodeMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return UrlQrCodeDTO.fromMO(self)
    }

    public override func apply(dto: any DTODescription) {
        guard let urlDTO = dto as? UrlQrCodeDTO else {
            print("[applyMOtoDTO]", "\(Self.self) apply failed: dto type: \(type(of: dto))")
            return
        }
        super.apply(dto: dto)
        self.strUrl = urlDTO.strUrl
    }
    
}
