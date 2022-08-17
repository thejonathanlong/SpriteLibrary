//
//  AnimationModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/16/22.
//

import SpriteKit

struct AnimationModel {
    let name: String
    let textures: [SKTexture]
    
    init(name: String, textures: [SKTexture]) {
        self.name = name
        self.textures = textures
    }
}
