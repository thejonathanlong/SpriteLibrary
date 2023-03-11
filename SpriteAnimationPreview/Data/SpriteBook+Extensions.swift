//
//  SpriteCollection+Extensions.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 10/21/22.
//

import CoreData
import Foundation

extension SpriteCollection: DataObject {
    var viewModel: SpriteProjectModel? {
        guard let name, let creationDate, let id else { return nil }
        let spritePreviews = spritePreviews?.compactMap { $0 as? SpritePreview }.compactMap { $0.viewModel }
        return SpriteProjectModel(name: name,
                        creationDate: creationDate,
                               id: id,
                               assets: spritePreviews ?? [])
    }
    
    static func predicate(id: String?) -> NSPredicate {
        NSPredicate(value: true)
    }
    
    static func sortDescriptors() -> [NSSortDescriptor] {
        [
            NSSortDescriptor(key: "creationDate", ascending: false),
            NSSortDescriptor(key: "name", ascending: true),
        ]
    }
}

extension SpriteCollection {

    private static var entityName: String {
        "SpriteCollection"
    }
    
    convenience init?(managedObjectContext: NSManagedObjectContext,
                      name: String,
                      id: String,
                      creationDate: Date) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: SpriteCollection.entityName, in: managedObjectContext) else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)
        self.name = name
        self.creationDate = creationDate
        self.id = id
    }
}
