//
//  SpriteProvider.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/16/22.
//

import SpriteKit

class DataProvider<T>: ObservableObject where T: DataObject {
    
//    enum State {
//        case empty
//        case loading
//        case loaded(viewModels: [T.ViewModel])
//    }

    let dataService: DataObjectService<T>
    
    let itemsPerFetch: Int
    
    var currentOffset = 0
    
//    @Published var state = State.empty
    
    private var data: [T] = [] {
        didSet {
            models = data.compactMap { $0.viewModel }
        }
    }
    
    @Published  var models: [T.ViewModel] = []
    
    var currentTask: Task<Void, Error>?
    
//    init(itemsPerFetch: Int,
//        dataService: DataService = DataService()) {
//        self.dataService = dataService
//        self.itemsPerFetch = itemsPerFetch
//
//        currentTask = Task(priority: .userInitiated) { [weak self] in
//            guard let self = self else { return }
//            // If the dataservice uses a queue of lower priority than userInitiated this will be priority inversion.
//            let spritePreviews = try await self.dataService.fetchSprites(offset: self.currentOffset,limit: itemsPerFetch)
//            self.currentOffset += spritePreviews.count
//            await self.updateCurrentState(previews: spritePreviews)
//        }
//    }
    
    init(itemsPerFetch: Int,
        dataService: DataObjectService<T> = DataObjectService<T>()) {
        self.dataService = dataService
        self.itemsPerFetch = itemsPerFetch
    }
    
    func fetch() {
        currentTask = Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            // If the dataservice uses a queue of lower priority than userInitiated this will be priority inversion.
            let spritePreviews = try await self.dataService.fetchAll(offset: self.currentOffset, limit: itemsPerFetch)
            self.currentOffset += spritePreviews.count
            self.data = spritePreviews
        }
    }
}
