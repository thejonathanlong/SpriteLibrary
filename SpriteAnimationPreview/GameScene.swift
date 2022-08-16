//
//  GameScene.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/12/22.
//

import SpriteKit
import GameplayKit

enum ButtonNames: String {
    case selectFiles
    
    var text: String {
        switch self {
            case .selectFiles:
                return "+"
        }
    }
}

protocol GameSceneDelegate: AnyObject {
    func didTapSelectFilesButton(_ button: SKLabelNode)
}

class GameScene: SKScene {
    
    private var labelNodes = [SKLabelNode]()
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    var sprites: [SKSpriteNode] = []
    
    let atlas = SKTextureAtlas(named: "Sprites")
    
    init(size: CGSize, gameSceneDelegate: GameSceneDelegate) {
        super.init(size: size)
        self.gameSceneDelegate = gameSceneDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        addPlusLabels(number: 18)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let labelContainingPos = labelNodes.filter { $0.frame.contains(pos) }
        if let label = labelContainingPos.first {
            gameSceneDelegate?.didTapSelectFilesButton(label)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func add(sprite: SKSpriteNode) {
        sprites.append(sprite)
        addChild(sprite)
    }
    
    func run(action: SKAction, for sprite: SKSpriteNode) {
        sprite.run(action)
    }
}

private extension GameScene {
    
    /// Add `number` labels with a `+` as SKNodes.
    /// - Parameter number: The number of labels to add. Must be divisible by 3.
    func addPlusLabels(number: Int) {
        assert(number % 3 == 0)
        var row: CGFloat = 0
        var col: CGFloat = 0
        for i in 0..<number {
            let texture = atlas.textureNamed("Bordered_Rectangle")
            let label = SKSpriteNode(texture: texture)
//            let label = SKLabelNode(text: ButtonNames.selectFiles.text)
            addChild(label)
            label.alpha = 0.0
            label.name = ButtonNames.selectFiles.rawValue
            label.color = SKColor.white
//            label.fontSize = 50
            let y: CGFloat = label.size.height * row + (size.height / 6.0)// * (row + 1) + (size.height / 6.0)//+ (size.height / 3.0)
            label.position = CGPoint(x: (size.width / 6.0) * col + (size.width / 12.0), y: y)
            
//            label.frame = CGRect(x: col * size.width / 3.0, y: size.height / 3.0 * row, width: size.width / 3.0, height: size.height / 3.0 )
            
            
            label.run(SKAction.fadeIn(withDuration: 1.0))
            
//            labelNodes.append(label)
            
            col += 1
            if ((i + 1) % 6) == 0 {
                row += 1
                col = 0
            }
        }
    }
}
