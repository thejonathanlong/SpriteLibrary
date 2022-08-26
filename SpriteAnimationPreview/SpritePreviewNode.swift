//
//  SpritePreviewNode.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/14/22.
//

import Foundation
import SpriteKit

class SpritePreviewNode: SKSpriteNode {
    lazy var nameLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = model.name
        label.fontColor = SKColor.white
        label.fontSize = 12
        return label
    }()
    
    lazy var addAnimationButton: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "+"
        label.fontSize = 20
        label.fontColor = SKColor.white
        return label
    }()
    
    let model: SpritePreviewModel
    
    override var position: CGPoint {
        didSet {
            updateChildNodesPosition()
        }
    }
    
    init(model: SpritePreviewModel, borderTexture: SKTexture) {
        self.model = model
        super.init(texture: borderTexture, color: .clear, size: borderTexture.size())
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.model = SpritePreviewModel(name: "", preview: SKTexture(), animations: [])
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchUp(at point: CGPoint) {
        
        if addAnimationButton.frame.contains(point) {
            print("Add animation to \(model.name)")
        }
    }
}

private extension SpritePreviewNode {
    func updateChildNodesPosition() {
        print("model: \(model)")
        addChild(nameLabel)
        addChild(addAnimationButton)
        
        addAnimationButton.position = CGPoint(x: (size.width / 2.0) * -1 + 30, y: (size.height / 2.0) - 30)
        
        let nameLabelY = -(size.height / 2.0) + 20
        nameLabel.position = CGPoint(x: 0, y: nameLabelY)
        
        let previewNode = SKSpriteNode(texture: model.preview)
        addChild(previewNode)
        previewNode.position = CGPoint(x: 0, y: 0)
    }
}
