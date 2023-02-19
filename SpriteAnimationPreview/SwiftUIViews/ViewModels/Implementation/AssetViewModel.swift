//
//  AssetViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/28/23.
//

import Combine
import UIKit

final class AssetViewModel: AssetViewModelDisplayable {
    
    enum Action {
        case didSelect(asset: AssetViewModel, id: String)
    }
    
    var name: String
    var icon: UIImage?
    var assets: [AssetViewModel]?
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var actionSubject = PassthroughSubject<Action, Never>()
    
    init(name: String, icon: UIImage? = nil, assets: [AssetViewModel]? = nil) {
        self.name = name
        self.icon = icon
        self.assets = assets
    }
    
    func didSelect() {
        actionSubject.send(.didSelect(asset: self, id: id))
    }
}
