//
//  DataStoreMiddleware.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/30/23.
//

import Combine
import Foundation

class DataService {
    lazy var spriteBookDataService = DataObjectService<SpriteBook>()
}

func dataStoreMiddleware(service: DataService) -> Middleware<AppState, AppAction> {
    return { _, action in
        switch action {
            case .spriteBooks(.fetchBooks):
//                Task {
                    let _ = try! service
                        .spriteBookDataService
                        .fetchAll()
//                }
                
            case let .projectAction(.createProject(name)):
                    service.spriteBookDataService.addSpriteBook(name: name)
                
            case .projectAction(.initiateAddProject):
                break
            case .saveData:
                //TODO: should not bang. Should probably catch the error and dispatch somehow?
                // We should return an appstate error if this throws
//                Task {
                    try! service.spriteBookDataService.save()
//                }
                
        }
        return Empty().eraseToAnyPublisher()
    }
}
