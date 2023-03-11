//
//  SpriteCollection+CoreDataProperties.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/28/22.
//
//

//import Foundation
//import CoreData
//
//
//extension SpriteCollection {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpriteCollection> {
//        return NSFetchRequest<SpriteCollection>(entityName: "SpriteCollection")
//    }
//
//    @NSManaged public var creationDate: Date?
//    @NSManaged public var id: String?
//    @NSManaged public var name: String?
//    @NSManaged public var spritePreviews: NSOrderedSet?
//
//}
//
//// MARK: Generated accessors for spritePreviews
//extension SpriteCollection {
//
//    @objc(insertObject:inSpritePreviewsAtIndex:)
//    @NSManaged public func insertIntoSpritePreviews(_ value: SpritePreview, at idx: Int)
//
//    @objc(removeObjectFromSpritePreviewsAtIndex:)
//    @NSManaged public func removeFromSpritePreviews(at idx: Int)
//
//    @objc(insertSpritePreviews:atIndexes:)
//    @NSManaged public func insertIntoSpritePreviews(_ values: [SpritePreview], at indexes: NSIndexSet)
//
//    @objc(removeSpritePreviewsAtIndexes:)
//    @NSManaged public func removeFromSpritePreviews(at indexes: NSIndexSet)
//
//    @objc(replaceObjectInSpritePreviewsAtIndex:withObject:)
//    @NSManaged public func replaceSpritePreviews(at idx: Int, with value: SpritePreview)
//
//    @objc(replaceSpritePreviewsAtIndexes:withSpritePreviews:)
//    @NSManaged public func replaceSpritePreviews(at indexes: NSIndexSet, with values: [SpritePreview])
//
//    @objc(addSpritePreviewsObject:)
//    @NSManaged public func addToSpritePreviews(_ value: SpritePreview)
//
//    @objc(removeSpritePreviewsObject:)
//    @NSManaged public func removeFromSpritePreviews(_ value: SpritePreview)
//
//    @objc(addSpritePreviews:)
//    @NSManaged public func addToSpritePreviews(_ values: NSOrderedSet)
//
//    @objc(removeSpritePreviews:)
//    @NSManaged public func removeFromSpritePreviews(_ values: NSOrderedSet)
//
//}
