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
        store.dispatch(.projectAction(.fetchProjects))
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
                        self.didSelect(project: project, projectList: projectListViewModel)
                    case let .addSprite(project: project):
                        self.addSprite(to: project)
                    case let .addAnimationToSprite(spriteUniqueId: spriteUniqueId):
                        break
                        
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
        store.dispatch(.projectAction(.fetchProjects))
        
    }
    
    private func addSprite(to project: SpriteProjectModel) {
        store.dispatch(.spriteAction(.initiateAddSprite(alertAction: [
            .ok(alertHandler: { [weak self] alertController in
                guard let name = alertController.textFields?.first?.text else {
                    // TODO: can we update the alert with an error?
                    return
                }
                self?.store.dispatch(.spriteAction(.chooseSpritePreview(documentSelectionHandler: { urls in
                    guard let url = urls.first else {
                        //TODO: throw or dispatch some sort of error is better
                        return
                    }
                    self?.store.dispatch(.spriteAction(.addSprite(name: name, url: url, project: project)))
                    self?.store.dispatch(.saveData)
                    self?.store.dispatch(.spriteAction(.fetchSprites(projectId: project.id)))
                })))
            }),
            .cancel(alertHandler: { _ in })
        ]
        )))
    }

    private func didSelect(project: SpriteProjectModel, projectList: ProjectListViewModel) {
        let details = SpriteProjectDetailsViewModel(selectedProject: project, spriteProvider: store.state.dataService.spriteDataService.resultPublisher)
        projectList.selectedProjectModel = details
    }
}

class ProjectBuilder {
    var spriteURL: URL?
    var projectName: String?
}
