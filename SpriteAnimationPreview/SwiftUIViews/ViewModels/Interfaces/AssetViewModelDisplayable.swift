//
//  AssetViewModelDisplayable.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/28/23.
//

import Combine
import SwiftUI

protocol AssetViewModelDisplayable: Identifiable {
    associatedtype Action
    
    var name: String { get }
    var icon: UIImage? { get }
    var assets: [Self]? { get }
    
    var actionPublisher: AnyPublisher<Action, Never> { get }
    
    func didSelect()
}

extension AssetViewModelDisplayable {
    var id: String {
        name
    }
}
