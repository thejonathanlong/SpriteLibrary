//
//  SpriteFactory.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/12/22.
//

import Foundation
import SpriteKit

class SpriteFactory {
    
    var textureAtlasDictionary = [String: Any]()
    
    var atlas = SKTextureAtlas(dictionary: [:])
    
    func add(urls: [URL]) {
        let moreTextures = urls.reduce([String: Any]()) { partialResult, url in
            var newResults = partialResult
            newResults[url.lastPathComponent] = url
            return newResults
        }
        
        moreTextures.forEach {
            textureAtlasDictionary[$0.key] = $0.value
        }
        
        self.atlas = SKTextureAtlas(dictionary: moreTextures)
    }
    
    func sprite(named: String) -> SKSpriteNode? {
        let texture = atlas.textureNamed(named)
        let sprite = SKSpriteNode(texture: texture)
        
        return sprite
    }
    
    func animationAction(prefix: String) -> SKAction {
        let textureNames = textureAtlasDictionary
            .filter { $0.key.hasPrefix(prefix) }
            .map { $0.key }
        let textures = textureNames.map { atlas.textureNamed($0) }
        let animation = SKAction.animate(with: textures, timePerFrame: 0.1)
        let forever = SKAction.repeatForever(animation)
        return forever
    }
    
    func animationAction(for urls: [URL]) -> SKAction {
        let textureNames = textureAtlasDictionary.map { $0.key }
        let textures = textureNames.map { atlas.textureNamed($0) }
        let animation = SKAction.animate(with: textures, timePerFrame: 0.2)
        let forever = SKAction.repeatForever(animation)
        return forever
    }
}
