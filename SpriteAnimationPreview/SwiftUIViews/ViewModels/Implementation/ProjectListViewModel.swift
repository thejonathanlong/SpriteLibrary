//
//  ProjectListViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/28/23.
//

import Combine
import SwiftUI

protocol SpriteCollectionProviderRequester {
    var provider: AnyPublisher<[SpriteProjectModel], Never> { get }
    func requestSpriteCollections()
}

class ProjectListViewModel: ObservableObject {
    @Published var projects = [SpriteProjectModel]() {
        didSet {
            if let firstProject = projects.first {
                didSelect(firstProject)
            }
        }
    }
    
    @Published var selectedProjectModel: SpriteProjectDetailsViewModel? = nil {
        didSet {
            detailsActionCancellable = selectedProjectModel?
                .actionPublisher
                .sink { [weak self] in
                    guard let self, let selectedProject = self.selectedProject else { return }
                    let action: Action
                    switch $0 {
                        case .addSprite:
                            action = .addSprite(project: selectedProject)
                        case .addAnimationToSprite(let spriteUniqueId):
                            action = .addAnimationToSprite(spriteUniqueId: spriteUniqueId)
                    }
                    self.actionSubject.send(action)
                }
        }
    }

    @Published var selectedProject: SpriteProjectModel?
    
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
    
    init(spriteBookProvider: SpriteCollectionProviderRequester) {
        self.spriteBookProvider = spriteBookProvider.provider
        
        spriteBookProvider
            .provider
            .assign(to: \.projects, onWeak: self)
            .store(in: &cancellables)
        
        spriteBookProvider.requestSpriteCollections()
    }
    
    func didSelect(_ asset: SpritePreviewModel) {
        actionSubject.send(.didSelect(asset: asset, id: asset.id))
    }
    
    func didSelect(_ project: SpriteProjectModel) {
        selectedProject = project
        actionSubject.send(.didSelectProject(project: project))
    }
    
    func addProject() {
        actionSubject.send(.addProject)
    }
}
