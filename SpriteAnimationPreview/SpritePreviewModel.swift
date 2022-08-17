//
//  SpritePreviewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/16/22.
//

import SpriteKit

struct SpritePreviewModel {
    let name: String
    let preview: SKTexture
    let animations: [AnimationModel]
    
    init(name: String,
         preview: SKTexture,
         animations: [AnimationModel]) {
        self.name = name
        self.preview = preview
        self.animations = animations
    }
}
