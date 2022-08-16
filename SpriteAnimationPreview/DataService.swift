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
    
    func addSprite(name: String, previewData: Data) {
        let spritePreview = SpritePreview()
        spritePreview.name = name
        spritePreview.previewData = previewData
    }
    
    func addAnimation(name: String, animationData: [Data], spriteName: String) async throws {
        guard let sprite = fetchSprite(name: spriteName) else { return }
        let newAnimation = Animation(
    }
    
    func fetchSprite(name: String) async throws -> SpritePreview? {
        let spriteFetchRequeset = SpritePreview.fetchRequest()
        spriteFetchRequeset.predicate = NSPredicate(format: "name == %@", name as NSString)
        let previews = try spriteFetchRequeset.execute()
        assert(previews.count == 0 || previews.count == 1, "There should either be 0 Sprites with this name, or 1 Sprite with this name.")
        return previews.first
    }
    
    
    
}