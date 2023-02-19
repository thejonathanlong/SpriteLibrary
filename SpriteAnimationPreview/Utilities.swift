//
//  Utilities.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 10/11/22.
//

import Foundation

struct ButtonNames {
    enum SceneLibrary: String {
        case selectFiles
        
        var text: String {
            switch self {
                case .selectFiles:
                    return "+ Sprite"
            }
        }
    }
    
    enum ProjectList: String {
        case addProject
        
        var text: String {
            switch self {
                case .addProject:
                    return "+"
            }
        }
    }
}
