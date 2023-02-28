//
//  SpriteBookModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 10/21/22.
//

import Combine
import UIKit

struct SpriteProjectModel: Identifiable {
    enum Action {
        case didSelect(asset: SpriteProjectModel, id: String)
    }
    
    private var actionSubject = PassthroughSubject<Action, Never>()
    
    let name: String
    
    let creationDate: Date
    
    let id: String
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var icon: UIImage? = nil
    
    var assets: [SpritePreviewModel]
    
    func didSelect() {
        actionSubject.send(.didSelect(asset: self, id: id))
    }
    
    public init(name: String, creationDate: Date, id: String, assets: [SpritePreviewModel] = []) {
        self.name = name
        self.creationDate = creationDate
        self.id = id
        self.assets = assets
    }

    public mutating func update(newAssets: [SpritePreviewModel]) {
        assets = newAssets
    }
}
