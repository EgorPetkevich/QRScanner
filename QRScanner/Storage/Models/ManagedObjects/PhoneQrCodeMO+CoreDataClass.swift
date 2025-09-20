//
//  PhoneQrCodeMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData

@objc(PhoneQrCodeMO)
public class PhoneQrCodeMO: BaseQrCodeMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return PhoneQrCodeDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescription) {
        guard let phoneDTO = dto as? PhoneQrCodeDTO else {
            print("[applyMOtoDTO]", "\(Self.self) apply failed: dto type: \(type(of: dto))")
            return
        }
        super.apply(dto: dto)
        self.phone = phoneDTO.phone
    }
    
}
