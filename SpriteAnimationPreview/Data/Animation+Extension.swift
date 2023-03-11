//
//  Animation+Extension.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 3/10/23.
//

import CoreData

extension Animation {
    private static var entityName: String {
        "Animation"
    }

    convenience init?(managedObjectContext: NSManagedObjectContext,
                      name: String,
                      animationData: [Data],
                      creationDate: Date = Date()) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: Animation.entityName, in: managedObjectContext) else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)

        self.name = name
        self.animationData = animationData
    }
}
