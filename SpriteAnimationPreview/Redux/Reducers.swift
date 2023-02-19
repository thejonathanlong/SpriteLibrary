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
        case .spriteBooks(let action):
            spriteBookReducer(state: &state, action: action)
        case .projectAction(let action):
            projectReducer(state: &state, action: action)
        case .saveData:
            break
            
    }
}

func spriteBookReducer(state: inout AppState, action: SpriteBookAction) {
    switch action {
        case .fetchBooks:
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
    }
}
