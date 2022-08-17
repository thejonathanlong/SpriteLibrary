//
//  GameViewController.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/12/22.
//

import UIKit
import SpriteKit
import GameplayKit
import UniformTypeIdentifiers

class GameViewController: UIViewController, GameSceneDelegate, UIDocumentPickerDelegate {
    
    let spriteFactory = SpriteFactory()
    
    lazy var gameScene = GameScene(size: CGSize(width: 480 * 2, height: 270 * 2), gameSceneDelegate: self)
    
    var selectedButton: SKLabelNode?
    
    override func loadView() {
        view = SKView()
    }
    
    func didTapSelectFilesButton(_ button: SKLabelNode) {
        selectedButton = button
        
        let alertController = UIAlertController(title: "Sprite Name", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Sprite Name" }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let nextAction = UIAlertAction(title: "Next", style: .default) {_ in 
            guard let text = alertController.textFields?.first?.text else { return }
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.png])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = true
            self.present(documentPicker, animated: true)
        }
        alertController.addAction(nextAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.png])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = true
            self.present(documentPicker, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = gameScene
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.backgroundColor = UIColor.white
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let firstURL = urls.first,
              let selectedButton = selectedButton
        else { return }
        selectedButton.removeFromParent()
        
        let name = firstURL.lastPathComponent
        spriteFactory.add(urls: urls)
        
//        guard let sprite = spriteFactory.sprite(named: name) else { return }
        
//        gameScene.add(sprite: sprite)
//        sprite.position = selectedButton.position
        
//        let animationAction = spriteFactory.animationAction(for: urls)
//        gameScene.run(action: animationAction, for: sprite)
//        let previewSpriteNode = SpritePreviewNode(texture: nil, color: .red, size: selectedButton.frame.size)
//        gameScene.add(sprite: previewSpriteNode)
        
    }
}
