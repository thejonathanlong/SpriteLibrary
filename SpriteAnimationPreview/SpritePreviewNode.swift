//
//  SpritePreviewNode.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/14/22.
//

import Foundation
import SpriteKit

class SpritePreviewNode: SKSpriteNode {
    
    enum PreviewState {
        case none
        case sprite(spriteNode: SKSpriteNode, animations: [String: [SKTexture]])
    }
    
    
    
//    lazy var borderTextureSprite = SKSpriteNode(texture: texture)
    
    var currentState = PreviewState.none
    
    let label = SKLabelNode(text: "Testing 1,2,3")
    
    override var position: CGPoint {
        didSet {
            updateChildNodesPosition()
        }
    }
    
    init(atlas: SKTextureAtlas) {
        let borderTexture = atlas.textureNamed("Bordered_Rectangle")
        super.init(texture: borderTexture, color: .clear, size: borderTexture.size())
        
//        addChild(label)
//        label.fontColor = SKColor.white
//        label.fontSize = 12
//        print("init pos: \(position)")
//        label.position = CGPoint(x: position.x, y: position.y - (size.height / 2.0) + 20.0)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpritePreviewNode {
    func apply(state newState: PreviewState) {
        switch (currentState, newState) {
            case (.none, .none):
                break
                
            case (.sprite(spriteNode: let sprite, animations: let animations), _),
                (_, .sprite(spriteNode: let sprite, animations: let animations)):
                addChild(sprite)
                sprite.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
                break

        }
    }
    
}

private extension SpritePreviewNode {
    func updateChildNodesPosition() {
        print("pos: \(position)")
        addChild(label)
        label.fontColor = SKColor.white
        label.fontSize = 12
        label.position = CGPoint(x: 0, y: -(size.height / 2.0) + 20)
    }
}
