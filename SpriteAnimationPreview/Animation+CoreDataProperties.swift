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

    @NSManaged public var animationData: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var sprite: SpritePreview?

}

extension Animation : Identifiable {

}
