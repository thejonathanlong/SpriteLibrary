//
//  AppState.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/30/23.
//

import UIKit

enum AppAction: CustomStringConvertible {
    case spriteAction(SpriteAction)
    case projectAction(ProjectAction)
    case saveData

    var description: String {
        return ""
    }
}

enum ProjectAction {
    case initiateAddProject(alertActions: [AlertAction])
    case createProject(name: String)
    case fetchProjects
}

enum SpriteAction {
    case initiateAddSprite(alertAction: [AlertAction])
    case chooseSpritePreview(documentSelectionHandler: ([URL]) -> Void)
    case addSprite(name: String, url: URL, project: SpriteProjectModel)
    case fetchSprites(projectId: String)
    case initiateAddAnimation(alertAction: [AlertAction])
    case selectAnimationFrames(documentSelectionHandler: ([URL]) -> Void)
    case addAnimation(animationName: String, spriteUniqueId: String, animationURLs: [URL])
}

struct AppState {
    var dataService = DataService()
}

struct SpriteBookState {
    var models: [SpriteProjectModel]
}
