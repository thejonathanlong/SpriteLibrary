//
//  SpriteLibraryScene.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/12/22.
//

import Combine
import GameplayKit
import SpriteKit
import SwiftUI

class SpriteLibraryScene: SKScene {

    enum Action {
        case addSprite
        case addAnimationToSprite(spriteUniqueId: String)
        case nextAnimation
        case previousAnimation
    }
    
    private let atlas = SKTextureAtlas(named: "Sprites")
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    private let actionSubject = PassthroughSubject<Action, Never>()
    
    var spritePreviewModels = [SpritePreviewModel]() {
        didSet {
            spritePreviewsDidChange()
        }
    }
    
    private var spritePreviewNodes = [SpritePreviewNode]()

    private var currentAnimationIndex: Int? = nil
    
    private var cancellables = Set<AnyCancellable>()

    private var touchdownStartingPoint = CGPoint.zero
    
    private lazy var addNode: SKLabelNode = {
        let addNode = SKLabelNode(text: ButtonNames.SceneLibrary.selectFiles.text)
        addNode.fontSize = 16
        addNode.position = CGPoint(x: 50, y: size.height - 50)
        return addNode
    }()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        addChild(addNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// MARK: - Interface
extension SpriteLibraryScene {
    func addNewSpritePreview(model: SpritePreviewModel) {
        spritePreviewModels.append(model)
    }
}

private extension SpriteLibraryScene {
        
    func spritePreviewsDidChange() {
        spritePreviewNodes.forEach {
            $0.removeFromParent()
        }
        var row: CGFloat = 2
        var col: CGFloat = 0
        let borderTexture = atlas.textureNamed("Bordered_Rectangle")
        for (index, model) in spritePreviewModels.enumerated() {
            let previewNode = SpritePreviewNode(model: model, borderTexture: borderTexture) { [weak self] in
                self?.actionSubject.send(.addAnimationToSprite(spriteUniqueId: $0))
            }
            spritePreviewNodes.append(previewNode)
            addChild(previewNode)
            
            let y: CGFloat = previewNode.size.height * row + (size.height / 6.0) + (row * 20)
            previewNode.position = CGPoint(x: (size.width / 6.0) * col + (size.width / 12.0) + 0, y: y)

            col += 1
            if ((index + 1) % 6) == 0 {
                row -= 1
                col = 0
            }
        }
    }
    
    private func showNextAnimation(for spritePreviewNode: SpritePreviewNode?, spritePreviewModel: SpritePreviewModel) {
        let nextAnimationIndex = (currentAnimationIndex ?? 0) + 1
        runAnimation(for: spritePreviewNode, spritePreviewModel: spritePreviewModel, at: nextAnimationIndex)
    }

    private func showPreviousAnimation(for spritePreviewNode: SpritePreviewNode?, spritePreviewModel: SpritePreviewModel) {
        let nextAnimationIndex = (currentAnimationIndex ?? 0) - 1
        runAnimation(for: spritePreviewNode, spritePreviewModel: spritePreviewModel, at: nextAnimationIndex)
    }

    private func runAnimation(for spritePreviewNode: SpritePreviewNode?, spritePreviewModel: SpritePreviewModel, at nextAnimationIndex: Int) {
        spritePreviewNode?.removeAllActions()
        guard nextAnimationIndex >= 0, nextAnimationIndex < spritePreviewModel.animations.count else {
            // TODO: remove actions and go back to poster?
            return
        }
        let animation = spritePreviewModel.animations[nextAnimationIndex]
        // TODO: Time per frame should be user specified. Either at creation of the animation or as a preference somewhere.
        let animationAction = SKAction.animate(with: animation.textures, timePerFrame: 0.1)
        let forever = SKAction.repeatForever(animationAction)
        spritePreviewNode?.run(forever)
        currentAnimationIndex = nextAnimationIndex

    }
}

// MARK: - Touch Handling
extension SpriteLibraryScene {
    func touchDown(atPoint pos : CGPoint) {
        touchdownStartingPoint = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let previewNode = spritePreviewNodes.filter({ $0.frame.contains(pos) }).first
        if addNode.frame.contains(pos) {
            actionSubject.send(.addSprite)
        } else if pos.x > touchdownStartingPoint.x {
            // swipe right
            let previewNodeIndex = spritePreviewNodes.firstIndex { $0 == previewNode }
            if let previewNodeIndex, previewNodeIndex >= 0 && previewNodeIndex < spritePreviewModels.count {
                let previewModel = spritePreviewModels[previewNodeIndex]
                showPreviousAnimation(for: previewNode, spritePreviewModel: previewModel)
            }
        } else {
            // swipe right
            let previewNodeIndex = spritePreviewNodes.firstIndex { $0 == previewNode }
            if let previewNodeIndex, previewNodeIndex >= 0 && previewNodeIndex < spritePreviewModels.count {
                let previewModel = spritePreviewModels[previewNodeIndex]
                showNextAnimation(for: previewNode, spritePreviewModel: previewModel)
            }

        }
        touchdownStartingPoint = .zero
    }
    
    func touchUp(touch: UITouch) {
        spritePreviewNodes.forEach {
            let point = touch.location(in: $0)
            $0.touchUp(at: point)
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
        for t in touches { self.touchUp(touch: t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        for t in touches { self.touchUp(touch: t) }
    }
}
