//
//  SpritePreview+CoreDataProperties.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/27/22.
//
//

import Foundation
import CoreData


extension SpritePreview {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpritePreview> {
        return NSFetchRequest<SpritePreview>(entityName: "SpritePreview")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var previewData: Data?
    @NSManaged public var uniqueID: String?
    @NSManaged public var animations: NSOrderedSet?

}

// MARK: Generated accessors for animations
extension SpritePreview {

    @objc(insertObject:inAnimationsAtIndex:)
    @NSManaged public func insertIntoAnimations(_ value: Animation, at idx: Int)

    @objc(removeObjectFromAnimationsAtIndex:)
    @NSManaged public func removeFromAnimations(at idx: Int)

    @objc(insertAnimations:atIndexes:)
    @NSManaged public func insertIntoAnimations(_ values: [Animation], at indexes: NSIndexSet)

    @objc(removeAnimationsAtIndexes:)
    @NSManaged public func removeFromAnimations(at indexes: NSIndexSet)

    @objc(replaceObjectInAnimationsAtIndex:withObject:)
    @NSManaged public func replaceAnimations(at idx: Int, with value: Animation)

    @objc(replaceAnimationsAtIndexes:withAnimations:)
    @NSManaged public func replaceAnimations(at indexes: NSIndexSet, with values: [Animation])

    @objc(addAnimationsObject:)
    @NSManaged public func addToAnimations(_ value: Animation)

    @objc(removeAnimationsObject:)
    @NSManaged public func removeFromAnimations(_ value: Animation)

    @objc(addAnimations:)
    @NSManaged public func addToAnimations(_ values: NSOrderedSet)

    @objc(removeAnimations:)
    @NSManaged public func removeFromAnimations(_ values: NSOrderedSet)

}

extension SpritePreview : Identifiable {
    
    private static var entityName: String {
        "SpritePreview"
    }

    convenience init?(managedObjectContext: NSManagedObjectContext,
                      name: String,
                      previewData: Data,
                      animations: NSOrderedSet?,
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
    }
}
