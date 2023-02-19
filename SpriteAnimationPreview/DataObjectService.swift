//
//  DataService.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/15/22.
//

import Combine
import CoreData
import Foundation

protocol DataObject: NSManagedObject {
    associatedtype ViewModel
    
    static func predicate(id: String?) -> NSPredicate
    static func fetchRequest() -> NSFetchRequest<Self>
    static func sortDescriptors() -> [NSSortDescriptor]
    
    var viewModel: ViewModel? { get }
}

class DataObjectService<T: DataObject> {
    
    enum State {
        case loaded
        case unloaded
    }
    
    
//    var dataQueue = DispatchQueue(label: "com.jlongstudios.dataService")
    
    let persistentContainer: NSPersistentCloudKitContainer
    
    var viewContext: NSManagedObjectContext
    
    var state = State.unloaded
    
    var actionPublisher: AnyPublisher<[T.ViewModel], Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private var actionSubject = CurrentValueSubject<[T.ViewModel], Never>([])
    
    init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "SpritePreviewDataBase")
        viewContext = persistentContainer.viewContext
        persistentContainer.loadPersistentStores(completionHandler: { [weak self] (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self?.state = .loaded
        })
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("JLO: \(urls[urls.count-1] as URL)")
    }
    
    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    @discardableResult func addSprite(name: String, previewData: Data, creationDate: Date = Date()) -> SpritePreview? {
        return SpritePreview(managedObjectContext: viewContext, name: name, previewData: previewData, animations: nil, creationDate: creationDate)
    }
    
    @discardableResult func addSpriteBook(name: String) -> SpriteBook? {
        return SpriteBook(managedObjectContext: viewContext, name: name, id: name, creationDate: Date())
    }
    
    func addAnimation(name: String, animationData: [Data], spriteID: String) async throws {
        guard let sprite = try await fetchSprite(uniqueID: spriteID),
              let newAnimation = Animation(managedObjectContext: viewContext, name: name, animationData: animationData)
        else { return }
        
        sprite.addToAnimations(newAnimation)
    }
    
    func fetch(id: String) async throws -> T? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = T.predicate(id: id)
        let result = try fetchRequest.execute()
        return result.first
    }
    
    func fetchAll() throws -> [T] {
        let fetchRequest = T.fetchRequest()
        fetchRequest.sortDescriptors = T.sortDescriptors()
        fetchRequest.predicate = NSPredicate(value: true)
        let result = try! viewContext.fetch(fetchRequest)
        actionSubject.send(result.compactMap { $0.viewModel })
        return result
    }
    
    func fetchAll(offset: Int, limit: Int) async throws -> [T] {
        let fetchRequest = T.fetchRequest()
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        fetchRequest.predicate = T.predicate(id: nil)
        fetchRequest.sortDescriptors = T.sortDescriptors()
        
        do {
            let results : [T] = try viewContext.fetch(fetchRequest)
            return results
        } catch let error {
            print("JLO: \(error)")
            return []
        }
    }
    
    func fetchSprite(name: String) async throws -> SpritePreview? {
        let spriteFetchRequeset = SpritePreview.fetchRequest()
        spriteFetchRequeset.predicate = NSPredicate(format: "name == %@", name as NSString)
        let previews = try spriteFetchRequeset.execute()
        assert(previews.count == 0 || previews.count == 1, "There should either be 0 Sprites with this name, or 1 Sprite with this name.")
        return previews.first
    }
    
    func fetchSprite(uniqueID: String) async throws -> SpritePreview? {
        let spriteFetchRequeset = SpritePreview.fetchRequest()
        spriteFetchRequeset.predicate = NSPredicate(format: "uniqueID == %@", uniqueID as NSString)
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
    
    func fetchSpriteBooks(offset: Int, limit: Int) async throws -> [SpriteBook] {
        let fetchRequest = SpriteBook.fetchRequest()
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        fetchRequest.predicate = NSPredicate(value: true)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        do {
            let results : [SpriteBook] = try viewContext.fetch(fetchRequest)
            return results
        } catch let error {
            print("JLO: \(error)")
            return []
        }
    }
    
    func fetchSpriteBook(uniqueID: String) async throws -> SpriteBook? {
        let spriteFetchRequeset = SpriteBook.fetchRequest()
        spriteFetchRequeset.predicate = NSPredicate(format: "uniqueID == %@", uniqueID as NSString)
        let books = try spriteFetchRequeset.execute()
        assert(books.count == 0 || books.count == 1, "There should either be 0 Books with this uniqueID, or 1 Sprite with this uniqueID.")
        return books.first
    }
}
