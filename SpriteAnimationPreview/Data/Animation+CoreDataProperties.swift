//
//  Animation+CoreDataProperties.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 3/10/23.
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
    @NSManaged public var creationDate: Date?
    @NSManaged public var sprite: SpritePreview?

}

extension Animation : Identifiable {

}
