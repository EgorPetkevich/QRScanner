//
//  TextQrCodeMO+CoreDataClass.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//
//

import Foundation
import CoreData

@objc(TextQrCodeMO)
public class TextQrCodeMO: BaseQrCodeMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return TextQrCodeDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescription) {
        guard let textDTO = dto as? TextQrCodeDTO else {
            print("[applyMOtoDTO]", "\(Self.self) apply failed: dto type: \(type(of: dto))")
            return
        }
        super.apply(dto: dto)
        self.strUrl = textDTO.strUrl
        self.text = textDTO.text
    }

}
