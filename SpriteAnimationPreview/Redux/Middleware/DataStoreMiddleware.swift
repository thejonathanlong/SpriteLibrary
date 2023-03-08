//
//  DataStoreMiddleware.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/30/23.
//

import Combine
import Foundation

class DataService {
    lazy var projectDataService = DataObjectService<SpriteBook>()
    lazy var spriteDataService = DataObjectService<SpritePreview>()
}

func dataStoreMiddleware(service: DataService) -> Middleware<AppState, AppAction> {
    return { _, action in
        switch action {
            case .projectAction(.fetchProjects):
//                Task {
                    let _ = try! service
                        .projectDataService
                        .fetchAll()
//                }
                
            case let .projectAction(.createProject(name)):
                    service.projectDataService.addSpriteBook(name: name)
                
            case .projectAction(.initiateAddProject):
                break
            case .saveData:
                //TODO: should not bang. Should probably catch the error and dispatch somehow?
                // We should return an appstate error if this throws
//                Task {
                    try! service.projectDataService.save()
                try! service.spriteDataService.save()
//                }
            case let .spriteAction(.addSprite(name: name, url: url, project: project)):
                guard let data = try? Data(contentsOf: url) else {
                    // TODO: Throwing or dispatching an error is better...
                    return Empty().eraseToAnyPublisher()
                }
                if let spriteProject = try? service.projectDataService.fetchSpriteBook(uniqueID: project.id) {
                    service.projectDataService.addSprite(name: name, previewData: data, project: spriteProject)
                } else {
                    //TODO: Throw error? Log error at least?
                    fatalError("Didn't get a project for \(project.id)")
                }

            case .spriteAction(.addAnimation(let animationName, let spriteUniqueId, let animationURLs)):
                let data = animationURLs.compactMap { try? Data(contentsOf: $0) }
                service.spriteDataService.addAnimation(name: animationName, animationData: data, spriteID: spriteUniqueId)
                
            case .spriteAction(.fetchSprites(let projectId)):
                let predicate = NSPredicate(format: "spriteBook.id == %@", projectId as NSString)
                _ = try! service.spriteDataService.fetch(predicate: predicate)

            case .spriteAction(.chooseSpritePreview):
                break
            case .spriteAction(.initiateAddSprite):
                break
            case .spriteAction(.initiateAddAnimation):
                break
            case .spriteAction(.selectAnimationFrames):
                break

        }
        return Empty().eraseToAnyPublisher()
    }
}
