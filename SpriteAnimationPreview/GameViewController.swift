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
    
    enum AddState {
        case sprite(NewSpriteState)
        case animation(name: String, spriteID: String)
    }
    
    lazy var spriteLibraryScene = SpriteLibraryScene(size: CGSize(width: 480 * 2, height: 270 * 2))
    
    let dataService = DataObjectService<SpritePreview>()
    
    var addState: AddState? = nil
    
    override func loadView() {
        view = SKView()
    }
    
    func didTapAddProjectButton(_ button: SKLabelNode) {
        let alertController = UIAlertController(title: "Add Project", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Project Name" }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let nextAction = UIAlertAction(title: "Next", style: .default) {[weak self]  _ in
            guard let self = self,
                  let name = alertController.textFields?.first?.text
            else { return }
            self.addState = .sprite(.init(name: name, creationDate: Date()))
            
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
    
    func didTapSelectFilesButton(_ button: SKLabelNode) {
        let alertController = UIAlertController(title: "Sprite Name", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Sprite Name" }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let nextAction = UIAlertAction(title: "Next", style: .default) {[weak self]  _ in
            guard let self = self,
                  let name = alertController.textFields?.first?.text
            else { return }
            self.addState = .sprite(.init(name: name, creationDate: Date()))
            
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
    
    func didTapAddAnimationForSpriteWith(uniqueID: String) {
        let alertController = UIAlertController(title: "Project Name", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Project Name" }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let nextAction = UIAlertAction(title: "Next", style: .default) {[weak self]  _ in
            guard let self = self,
                  let name = alertController.textFields?.first?.text
            else { return }
            self.addState = .animation(name: name, spriteID: uniqueID)
            
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
            documentPicker.allowsMultipleSelection = true
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
//        switch addState {
//            case .some(.sprite(let newSpriteState)):
//                addSprite(url: urls.first, newSpriteState: newSpriteState)
//            case .some(.animation(name: let name, spriteID: let spriteID)):
//                addAnimation(urls: urls, spriteID: spriteID, animationName: name)
//            case .none:
//                assert(false, "Did you forget to set the add state?")
//        }
    }
}

private extension GameViewController {
//    private func addSprite(url: URL?, newSpriteState: NewSpriteState) {
//        guard let url = url,
//              let data = try? Data(contentsOf: url),
//              let image = UIImage(data: data)
//        else { return }
//
//        // Let's just tell the scene to add this thing, then it can tell the spriteprovider thing (which needs a new name) to add the thing.
//
//        var newSpriteState = newSpriteState
//        newSpriteState.previewImage = image
//        let spritePreview = dataService.addSprite(name: newSpriteState.name, previewData: data, creationDate: newSpriteState.creationDate)
//        if let spritePreviewModel = SpritePreviewModel(spritePreview: spritePreview) {
//            spriteLibraryScene.addNewSpritePreview(model: spritePreviewModel)
//        }
//        try? dataService.save()
//    }
    
    private func addAnimation(urls: [URL], spriteID: String, animationName: String) {
        let data = urls.compactMap { try? Data(contentsOf: $0) }
        Task {
            try await dataService.addAnimation(name: animationName, animationData: data, spriteID: spriteID)
        }
        
    }
}
