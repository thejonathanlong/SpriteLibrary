//
//  SpritePreview+Extensions.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 10/21/22.
//

import CoreData
import Foundation

extension SpritePreview: DataObject {
    static func sortDescriptors() -> [NSSortDescriptor] {
        []
    }
    
    typealias ViewModel = SpritePreviewModel
    
    static func predicate(id: String?) -> NSPredicate {
        guard let id else { return NSPredicate(value: true) }
        return NSPredicate(format: "name == %@", id as NSString)
    }
    
    var viewModel: SpritePreviewModel? {
        SpritePreviewModel(spritePreview: self)
    }
}

extension SpritePreview {
    
    private static var entityName: String {
        "SpritePreview"
    }

    convenience init?(managedObjectContext: NSManagedObjectContext,
                      name: String,
                      previewData: Data,
                      project: SpriteCollection,
                      animations: NSSet?,
                      creationDate: Date = Date(),
                      uniqueID: String = "\(UUID())") {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: SpritePreview.entityName, in: managedObjectContext) else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)

        self.name = name
        self.uniqueID = uniqueID
        self.previewData = previewData
        self.animations = animations
        self.creationDate = creationDate
        self.collection = project
    }
}
