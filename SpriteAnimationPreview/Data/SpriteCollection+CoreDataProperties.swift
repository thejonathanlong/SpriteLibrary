//
//  SpriteCollection+CoreDataProperties.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 3/10/23.
//
//

import Foundation
import CoreData


extension SpriteCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpriteCollection> {
        return NSFetchRequest<SpriteCollection>(entityName: "SpriteCollection")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var spritePreviews: NSSet?

}

// MARK: Generated accessors for spritePreviews
extension SpriteCollection {

    @objc(addSpritePreviewsObject:)
    @NSManaged public func addToSpritePreviews(_ value: SpritePreview)

    @objc(removeSpritePreviewsObject:)
    @NSManaged public func removeFromSpritePreviews(_ value: SpritePreview)

    @objc(addSpritePreviews:)
    @NSManaged public func addToSpritePreviews(_ values: NSSet)

    @objc(removeSpritePreviews:)
    @NSManaged public func removeFromSpritePreviews(_ values: NSSet)

}

extension SpriteCollection : Identifiable {

}
