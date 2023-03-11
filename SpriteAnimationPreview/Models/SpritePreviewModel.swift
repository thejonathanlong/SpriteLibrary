//
//  SpritePreviewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/16/22.
//

import SpriteKit

struct SpritePreviewModel: Identifiable {
    let name: String
    let uniqueID: String
    let preview: SKTexture
    let previewImage: UIImage
    let animations: [AnimationModel]
    
    var id: String {
        uniqueID
    }
    
    init(name: String,
         uniqueID: String,
         preview: SKTexture,
         previewImage: UIImage,
         animations: [AnimationModel]) {
        self.name = name
        self.uniqueID = uniqueID
        self.preview = preview
        self.animations = animations
        self.previewImage = previewImage
    }
    
    init?(spritePreview: SpritePreview?) {
        guard let name = spritePreview?.name,
              let uniqueID = spritePreview?.uniqueID,
              let previewData = spritePreview?.previewData,
              let previewImage = UIImage(data: previewData),
              let animations = Array(spritePreview?.animations ?? Set<Animation>() as NSSet) as? Array<Animation> else {
            return nil
        }
        let animationModels = animations
            .sorted {
                guard let firstDate = $0.creationDate,
                      let secondDate = $1.creationDate
                else { return true }
                return firstDate < secondDate
            }
            .compactMap { (animation) -> AnimationModel? in
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
        self.init(name: name,
                  uniqueID: uniqueID,
                  preview: SKTexture(image: previewImage),
                  previewImage: previewImage,
                  animations: animationModels)
    }
}
