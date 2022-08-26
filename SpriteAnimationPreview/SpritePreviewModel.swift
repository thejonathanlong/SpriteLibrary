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
    
    init?(spritePreview: SpritePreview?) {
        guard let name = spritePreview?.name,
              let preview = spritePreview?.previewData,
              let previewImage = UIImage(data: preview),
              let animations = spritePreview?.animations?.array as? Array<Animation> else {
            return nil
        }
        let animationModels = animations.compactMap { (animation) -> AnimationModel? in
            guard let name = animation.name,
                  let textureData = animation.animationData else {
                return nil
            }
            let textures = textureData.compactMap { (textureData) -> SKTexture? in
                guard let textImage = UIImage(data: textureData) else { return nil }
                return SKTexture(image: textImage)
            }
            return AnimationModel(name: name, textures: textures)
        }
        self.init(name: name, preview: SKTexture(image: previewImage), animations: animationModels)
    }
}
