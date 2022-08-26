//
//  SpriteProvider.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/16/22.
//

import SpriteKit
import OrderedCollections

class SpriteProvider: ObservableObject {
    
    enum State {
        case empty
        case loading
        case loaded(spritePreviews: [SpritePreviewModel])
    }

    let dataService: DataService
    
    let itemsPerFetch: Int
    
    var currentOffset = 0
    
    @Published var state = State.empty
    
    var currentTask: Task<Void, Error>?
    
    init(itemsPerFetch: Int,
        dataService: DataService = DataService()) {
        self.dataService = dataService
        self.itemsPerFetch = itemsPerFetch
        
        currentTask = Task(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            let spritePreviews = try await self.dataService.fetchSprites(offset: self.currentOffset,limit: itemsPerFetch)
            self.currentOffset += spritePreviews.count
            await self.updateCurrentState(previews: spritePreviews)
        }
    }
    
    @MainActor func updateCurrentState(previews: [SpritePreview]) {
        let previewModels = previews.compactMap { SpritePreviewModel(spritePreview: $0) }
        state = .loaded(spritePreviews: previewModels)
    }
}
