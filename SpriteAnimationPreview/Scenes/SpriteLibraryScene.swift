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

protocol SpriteLibrarySceneDelegate: AnyObject {
    func didTapSelectFilesButton(_ button: SKLabelNode)
    func didTapAddAnimationForSpriteWith(uniqueID: String)
}

class SpriteLibraryScene: SKScene {
    
//    weak var spriteLibraryDelegate: SpriteLibrarySceneDelegate?
    
    enum Action {
        case addSprite
        case addAnimationToSprite(spriteUniqueId: String)
    }
    
    private let atlas = SKTextureAtlas(named: "Sprites")
    
//    @ObservedObject var spriteProvider: DataProvider<SpritePreview>
    
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
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var addNode: SKLabelNode = {
        let addNode = SKLabelNode(text: ButtonNames.SceneLibrary.selectFiles.text)
        addNode.fontSize = 16
        addNode.position = CGPoint(x: 50, y: size.height - 50)
        return addNode
    }()
    
    //    init(size: CGSize,
    //         spriteProvider: DataProvider<SpritePreview> = DataProvider<SpritePreview>(itemsPerFetch: 18)) {
    //        self.spriteProvider = spriteProvider
//        super.init(size: size)
//        // TODO: Change this from a delegate to an action publisher?
//        self.spriteLibraryDelegate = nil
//    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        addChild(addNode)
        
//        spriteProvider
//            .$models
//            .assign(to: \.spritePreviewModels, onWeak: self)
//            .store(in: &cancellables)
//
//        spriteProvider
//            .$state
//            .compactMap { (state: SpriteProvider.State) -> [SpritePreviewModel] in
//                switch state {
//                    case .empty, .loading:
//                        return []
//                    case .loaded(spritePreviews: let previews):
//                        return previews
//                }
//            }
//            .assign(to: \.spritePreviewModels, onWeak: self)
//            .store(in: &cancellables)
        
        
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
            
            let y: CGFloat = previewNode.size.height * row + (size.height / 6.0) - 10
            previewNode.position = CGPoint(x: (size.width / 6.0) * col + (size.width / 12.0) + 20, y: y)

            col += 1
            if ((index + 1) % 6) == 0 {
                row -= 1
                col = 0
            }
            
        }
    }
    
    private func addAnimationForSprite(with uniqueID: String) {
        
    }
}

// MARK: - Touch Handling
extension SpriteLibraryScene {
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if addNode.frame.contains(pos) {
            actionSubject.send(.addSprite)
        }
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
