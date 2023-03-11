//
//  SpritePreview+CoreDataProperties.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 3/10/23.
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
    @NSManaged public var animations: NSSet?
    @NSManaged public var collection: SpriteCollection?

}

// MARK: Generated accessors for animations
extension SpritePreview {

    @objc(addAnimationsObject:)
    @NSManaged public func addToAnimations(_ value: Animation)

    @objc(removeAnimationsObject:)
    @NSManaged public func removeFromAnimations(_ value: Animation)

    @objc(addAnimations:)
    @NSManaged public func addToAnimations(_ values: NSSet)

    @objc(removeAnimations:)
    @NSManaged public func removeFromAnimations(_ values: NSSet)

}
