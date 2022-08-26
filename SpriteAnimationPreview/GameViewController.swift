//
//  GameViewController.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/12/22.
//

import Foundation
import GameplayKit
import SpriteKit
import UIKit
import UniformTypeIdentifiers

class GameViewController: UIViewController, SpriteLibrarySceneDelegate, UIDocumentPickerDelegate {
    
    let spriteFactory = SpriteFactory()
    
    lazy var spriteLibraryScene = SpriteLibraryScene(size: CGSize(width: 480 * 2, height: 270 * 2), spriteLibraryDelegate: self)
    
    var selectedButton: SKLabelNode?
    
    var newSpriteState: NewSpriteState?
    
    let dataService = DataService()
    
    override func loadView() {
        view = SKView()
    }
    
    func didTapSelectFilesButton(_ button: SKLabelNode) {
        selectedButton = button
        
        let alertController = UIAlertController(title: "Sprite Name", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Sprite Name" }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let nextAction = UIAlertAction(title: "Next", style: .default) {[weak self]  _ in
            guard let self = self,
                  let name = alertController.textFields?.first?.text
            else { return }
            
            self.newSpriteState = NewSpriteState(name: name, creationDate: Date(), previewImage: nil)
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.png, UTType.gif])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = true
            self.present(documentPicker, animated: true)
        }
        alertController.addAction(nextAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.png])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = spriteLibraryScene
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
              let data = try? Data(contentsOf: firstURL),
              let image = UIImage(data: data)
        else { return }
        
        newSpriteState?.previewImage = image
        if let newSpriteState = newSpriteState {
            let spritePreview = dataService.addSprite(name: newSpriteState.name, previewData: data, creationDate: newSpriteState.creationDate)
            if let spritePreviewModel = SpritePreviewModel(spritePreview: spritePreview) {
                spriteLibraryScene.addNewSpritePreview(model: spritePreviewModel)
            }
            try? dataService.save()
            self.newSpriteState = nil
        }
    }
}
