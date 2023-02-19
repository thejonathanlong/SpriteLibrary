//
//  StoreGlue.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/31/23.
//

import Combine
import UIKit

class StoreGlue: NSObject, UIDocumentPickerDelegate {
    let store: AppStore
    
    var cancellables = Set<AnyCancellable>()
    
    init(store: AppStore) {
        self.store = store
    }
    
    func requestSpriteBooks() {
        store.dispatch(.spriteBooks(.fetchBooks))
    }
    
    func subscribeTo(projectListViewModel: ProjectListViewModel) {
        projectListViewModel
            .actionPublisher
            .sink { [weak self] action in
                guard let self else { return }
                switch action {
                    case .addProject:
//                        self.store.dispatch(.projectAction(.initiateAddProject(delegate: self)))
                        self.store.dispatch(.projectAction(.initiateAddProject(alertActions: [
                            .ok(alertHandler: self.handleAddProject),
                            .cancel(alertHandler: { _ in })
                        ])))
                    case let .didSelect(asset: SpritePreviewModel, id: String):
                        break
                    case let .didSelectProject(project: project):
                        break
//                        self.showProjectDetails(project)
                        
                }
            }
            .store(in: &cancellables)
    }
    
    func handleAddProject(alertController: UIAlertController) {
        guard let firstTextField = alertController.textFields?.first else {
            assert(false, "There should only be one text field in this alert.")
            return
        }
        
        guard let name = firstTextField.text else {
            //TODO: Here we should dispatch an action with an erro so we can present an alert on completion saying that you must specify a nonempty name
            //TODO: also should handle duplicate names here as well.
            return
        }
        
        //TODO: This probably shouldn't be synchronous... but it is...
        store.dispatch(.projectAction(.createProject(name: name)))
        store.dispatch(.saveData)
        store.dispatch(.spriteBooks(.fetchBooks))
        
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

class ProjectBuilder {
    var spriteURL: URL?
    var projectName: String?
}
