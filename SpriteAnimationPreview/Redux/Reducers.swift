//
//  Reducers.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/30/23.
//

import Foundation

import Foundation

typealias Reducer<State, Action> = (inout State, Action) -> Void

// MARK: - AppReducer
func appReducer(state: inout AppState, action: AppAction) {
    switch action {
        case .spriteAction(let action):
            spriteActionReducer(state: &state, action: action)
        case .projectAction(let action):
            projectReducer(state: &state, action: action)
        case .saveData:
            break
            
    }
}

func spriteActionReducer(state: inout AppState, action: SpriteAction) {
    switch action {
        case .initiateAddSprite(let alertAction):
            Router.shared.route(to: .alert(.input(title: "Add Sprite", message: "Sprite Name", defaultText: "", actions: alertAction), { }))
            
        case .chooseSpritePreview(let documentSelectionHandler):
            Router.shared.route(to: .documentPicker(documentSelectionHandler: documentSelectionHandler))

        case .addSprite://(name: let name, url: let url, creationDate: let creationDate):
            break

        case .fetchSprites:
            break

        case .initiateAddAnimation(let alertActions):
            Router.shared.route(to: .alert(.input(title: "Add Animation", message: "Animation Name", defaultText: "", actions: alertActions), {
            }))

        case .selectAnimationFrames(let documentSelectionHandler):
            Router.shared.route(to: .documentPicker(documentSelectionHandler: documentSelectionHandler))

        case .addAnimation:
            break

    }
}

func projectReducer(state: inout AppState, action: ProjectAction) {
    switch action {
        case .initiateAddProject(let alertActions):
            AppLifeCycleManager.shared
                .router
                .route(to: .alert(.input(title: "Project Name", message: "", defaultText: "", actions: alertActions), {
                }))
//            AppLifeCycleManager.shared.router.route(to: .documentPicker)
        case .createProject:
            break
        case .fetchProjects:
            break
    }
}
