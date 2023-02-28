//
//  AppState.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/30/23.
//

import UIKit

enum AppAction: CustomStringConvertible {
//    case storyCreation(StoryCreationAction)
//    case storyCard(StoryListAction)
//    case dataStore(DataStoreAction)
//    case recording(RecordingAction)
//    case sticker(StickerAction)
//    case failure(Error)
    case spriteAction(SpriteAction)
    case projectAction(ProjectAction)
    case saveData

    var description: String {
//        switch self {
//        case .storyCreation(let storyCreationAction):
//            return storyCreationAction.description
//
//        case .storyCard(let storyListAction):
//            return storyListAction.description
//
//        case .dataStore(let dataStoreAction):
//            return dataStoreAction.description
//
//        case .recording(let recordingAction):
//            return recordingAction.description
//
//        case .sticker(let stickerAction):
//            return stickerAction.description
//
//        case .failure(let error):
//            return error.localizedDescription
//        }
        return ""
    }
}

enum ProjectAction {
    case initiateAddProject(alertActions: [AlertAction])
//    case initiateAddProject(delegate: UIDocumentPickerDelegate)
    case createProject(name: String)
    case fetchProjects
}

enum SpriteAction {
    case initiateAddSprite(alertAction: [AlertAction])
    case chooseSpritePreview(documentSelectionHandler: ([URL]) -> Void)
    case addSprite(name: String, url: URL, project: SpriteProjectModel)
    case fetchSprites(projectId: String)
}

struct AppState {
//    var storyListState: StoryListState
//    var storyCreationState: StoryCreationState
//    var mediaState = MediaState()
//    var stickerState = StickerState()
//
    lazy var dataService = DataService()
}

//struct DataState {
//    lazy var spriteBookDataService = DataObjectService<SpriteBook>()
//}

struct SpriteBookState {
    var models: [SpriteProjectModel]
}
