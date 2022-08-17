//
//  GameScene.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/12/22.
//


import GameplayKit
import SpriteKit
import SwiftUI

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
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    let atlas = SKTextureAtlas(named: "Sprites")
    
    @ObservedObject var spriteProvider: SpriteProvider
    
    init(size: CGSize,
         gameSceneDelegate: GameSceneDelegate,
         spriteProvider: SpriteProvider) {
        self.spriteProvider = spriteProvider
        super.init(size: size)
        self.gameSceneDelegate = gameSceneDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
//        addPlusLabels(number: 18)
//        spriteProvider
//            .$sprites
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
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
            let previewNode = SpritePreviewNode(atlas: atlas)
            addChild(previewNode)

            let y: CGFloat = previewNode.size.height * row + (size.height / 6.0)
            previewNode.position = CGPoint(x: (size.width / 6.0) * col + (size.width / 12.0), y: y)

            col += 1
            if ((i + 1) % 6) == 0 {
                row += 1
                col = 0
            }
        }
    }
}

// MARK: - Touch Handling
extension GameScene {
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
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
}
