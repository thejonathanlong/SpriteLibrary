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
    
    override var position: CGPoint {
        didSet {
            updateChildNodesPosition()
        }
    }
    
    let model: SpritePreviewModel
    
    
    /// Called when an animation should be added.
    /// Parameter is the uniqueID of the model.
    let addAnimationCallback: ((String) -> Void)?
    
    init(model: SpritePreviewModel, borderTexture: SKTexture, addAnimation: ((String) -> Void)?) {
        self.model = model
        self.addAnimationCallback = addAnimation
        super.init(texture: borderTexture, color: .clear, size: borderTexture.size())
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.model = SpritePreviewModel(name: "", uniqueID: "", preview: SKTexture(), previewImage: UIImage(), animations: [])
        self.addAnimationCallback = nil
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchUp(at point: CGPoint) {
        if addAnimationButton.frame.contains(point) {
            addAnimationCallback?(model.uniqueID)
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
        addAnimationSymbols()
    }
    
    func addAnimationSymbols() {
        // If there are no animations do not show the indicator
        guard model.animations.count > 0 else { return }
        
        let radius = 3
        let centerPoint = CGPoint(x: (size.width / 2.0) * 0,
                                  y: (size.height / 2.0) * -1 + 10)
        let numberOfAnimations = model.animations.count + 1
        let startingPoint = CGPoint(x: centerPoint.x - CGFloat(radius * numberOfAnimations),
                                    y: centerPoint.y)
        for i in (0..<numberOfAnimations) {
            let currentPosition = CGPoint(x: startingPoint.x * CGFloat(i),
                                          y: startingPoint.y)
            let circle = SKShapeNode(circleOfRadius: CGFloat(radius))
            circle.position = currentPosition
            circle.strokeColor = SKColor.white
            circle.glowWidth = 0.1
            
            addChild(circle)
        }
        
        
        
    }
}
