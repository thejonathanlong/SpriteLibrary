//
//  DataService.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/15/22.
//

import CoreData
import Foundation

class DataService {
    
    enum State {
        case loaded
        case unloaded
    }
    
    
//    var dataQueue = DispatchQueue(label: "com.jlongstudios.dataService")
    
    let persistentContainer: NSPersistentCloudKitContainer
    
    var viewContext: NSManagedObjectContext
    
    var state = State.unloaded
    
    init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "SpritePreviewDataBase")
        viewContext = persistentContainer.viewContext
        persistentContainer.loadPersistentStores(completionHandler: { [weak self] (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self?.state = .loaded
        })
    }
    
    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    @discardableResult func addSprite(name: String, previewData: Data, creationDate: Date = Date()) -> SpritePreview? {
        return SpritePreview(managedObjectContext: viewContext, name: name, previewData: previewData, animations: nil, creationDate: creationDate)
    }
    
    func addAnimation(name: String, animationData: [Data], spriteName: String) async throws {
        guard let sprite = try await fetchSprite(name: spriteName),
              let newAnimation = Animation(managedObjectContext: viewContext, name: name, animationData: animationData)
        else { return }
        
        sprite.addToAnimations(newAnimation)
    }
    
    func fetchSprite(name: String) async throws -> SpritePreview? {
        let spriteFetchRequeset = SpritePreview.fetchRequest()
        spriteFetchRequeset.predicate = NSPredicate(format: "name == %@", name as NSString)
        let previews = try spriteFetchRequeset.execute()
        assert(previews.count == 0 || previews.count == 1, "There should either be 0 Sprites with this name, or 1 Sprite with this name.")
        return previews.first
    }
    
    func fetchSprites(offset: Int, limit: Int) async throws -> [SpritePreview] {
        let fetchRequest = SpritePreview.fetchRequest()
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        fetchRequest.predicate = NSPredicate(value: true)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        do {
            let results : [SpritePreview] = try viewContext.fetch(fetchRequest)
            return results
        } catch let error {
            print("JLO: \(error)")
            return []
        }
    }
    
    
    
}
