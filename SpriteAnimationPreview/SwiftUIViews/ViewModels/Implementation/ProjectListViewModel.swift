//
//  ProjectListViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/28/23.
//

import Combine
import SwiftUI

protocol SpriteBookProviderRequester {
    var provider: AnyPublisher<[SpriteProjectModel], Never> { get }
    func requestSpriteBooks()
}

class ProjectListViewModel: ObservableObject {
    @Published var projects = [SpriteProjectModel]()
    
    @Published var selectedProjectModel: SpriteProjectDetailsViewModel? = nil
    
    private let spriteBookProvider: AnyPublisher<[SpriteProjectModel], Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    private var detailsActionCancellable: AnyCancellable?
    
    private var actionSubject = PassthroughSubject<Action, Never>()
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    enum Action {
        case addProject
        case didSelect(asset: SpritePreviewModel, id: String)
        case didSelectProject(project: SpriteProjectModel)
        case addSprite(project: SpriteProjectModel)
        case addAnimationToSprite(spriteUniqueId: String)
    }
    
    init(spriteBookProvider: SpriteBookProviderRequester) {
        self.spriteBookProvider = spriteBookProvider.provider
        
        spriteBookProvider
            .provider
            .assign(to: \.projects, onWeak: self)
            .store(in: &cancellables)
        
        spriteBookProvider.requestSpriteBooks()
    }
    
    func didSelect(_ asset: SpritePreviewModel) {
        actionSubject.send(.didSelect(asset: asset, id: asset.id))
    }
    
    func didSelect(_ project: SpriteProjectModel) {
        detailsActionCancellable = nil
        selectedProjectModel = SpriteProjectDetailsViewModel(selectedProject: project)
        detailsActionCancellable = selectedProjectModel?
            .actionPublisher
            .sink { [weak self] in
                let action: Action
                switch $0 {
                    case .addSprite:
                        action = .addSprite(project: project)
                    case .addAnimationToSprite(let spriteUniqueId):
                        action = .addAnimationToSprite(spriteUniqueId: spriteUniqueId)
                }
                self?.actionSubject.send(action)
            }
    }
    
    func addProject() {
        actionSubject.send(.addProject)
    }
    
//    private func fetchAll() {
//        Task {
//            do {
//                self.projects = try await dataService.fetchAll().compactMap { $0.viewModel }
//            } catch {
//                //TODO: Handle this..
//            }
//        }
//
//    }
}