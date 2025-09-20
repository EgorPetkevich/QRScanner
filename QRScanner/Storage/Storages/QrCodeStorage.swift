//
//  QrCodeStorage.swift
//  Storage
//
//  Created by George Popkich on 1.08.24.
//

import Foundation
import CoreData

public class QrCodeStorage<DTO: DTODescription> {
    
    public typealias CompletionHandler = (Bool) -> Void
    
    public init() {}
    
    private func fetchMO(predicate: NSPredicate? = nil,
                         sortDescriptors: [NSSortDescriptor] = [],
                         context: NSManagedObjectContext)
    -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let results = try? context.fetch(request)
        return results ?? []
    }
    
    public func fetch(predicate: NSPredicate? = nil,
                      sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescription] {
        let context = CoreDataService.shared.mainContext
        return fetchMO(predicate: predicate,
                       sortDescriptors: sortDescriptors,
                       context: context)
        .compactMap { $0.toDTO() }
    }
    
    public func create(dto: any DTODescription,
                       complition: CompletionHandler? = nil) {
        let context = CoreDataService.shared.mainContext
        context.perform {
            let _ = dto.createMO(context: context)
            CoreDataService.shared.saveContext(context: context,
                                               completion: complition)
        }
    }
    
    public func delete(dto: any DTODescription,
                       complition: CompletionHandler? = nil) {
        let context = CoreDataService.shared.mainContext
        context.perform { [weak self] in
            guard let mo = self?.fetchMO(
                predicate: .QRCode.qrCode(byId: dto.id),
                context: context).first
            else { return }
            context.delete(mo)
            CoreDataService.shared.saveContext(context: context,
                                               completion: complition)
        }
    }
    
    public func deleteSelected(dtos: [any DTODescription],
                          complition: CompletionHandler? = nil) {
        let context = CoreDataService.shared.mainContext
        context.perform { [weak self] in
            let ids = dtos.map { $0.id }
            let mos = self?.fetchMO(
                predicate: .QRCode.qrCodes(in: ids),
                context: context)
            mos?.forEach(context.delete)
            CoreDataService.shared.saveContext(context: context,
                                               completion: complition)
        }
    }
    
}
