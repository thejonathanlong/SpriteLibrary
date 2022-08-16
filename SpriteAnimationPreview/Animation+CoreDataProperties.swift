//
//  Animation+CoreDataProperties.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/15/22.
//
//

import Foundation
import CoreData


extension Animation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Animation> {
        return NSFetchRequest<Animation>(entityName: "Animation")
    }

    @NSManaged public var animationData: [Data]?
    @NSManaged public var name: String?
    @NSManaged public var sprite: SpritePreview?

}

extension Animation : Identifiable {
    private static var entityName: String {
        "Animation"
    }

    convenience init?(managedObjectContext: NSManagedObjectContext,
                      name: String,
                      animationData: [Data]) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: Animation.entityName, in: managedObjectContext) else {
            return nil
        }
        self.init(entity: entityDescription, insertInto: managedObjectContext)

        self.name = name
        self.animationData = animationData
    }
}
