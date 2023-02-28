//
//  SpriteProjectDetailsViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 2/19/23.
//

import Combine
import Foundation

protocol SpriteProviderInterface {
    func provider(for projectId: String) -> AnyPublisher<[SpritePreviewModel], Never>
}

class SpriteProjectDetailsViewModel {
    var selectedProject: SpriteProjectModel
    
    private var actionSubject = PassthroughSubject<SpriteLibraryScene.Action, Never>()
    
    lazy var actionPublisher: AnyPublisher<SpriteLibraryScene.Action, Never> = actionSubject.eraseToAnyPublisher()
    
    var cancellables = Set<AnyCancellable>()
    
    init(selectedProject: SpriteProjectModel, spriteProvider: AnyPublisher<[SpritePreviewModel], Never>) {
        self.selectedProject = selectedProject

        spriteProvider
            .sink { [weak self] previewModels in
                guard let self, !previewModels.isEmpty else { return }
                self.selectedProject.update(newAssets: previewModels)
                self.scene.spritePreviewModels = previewModels
            }
            .store(in: &cancellables)
    }
    
    lazy var scene: SpriteLibraryScene = {
        let scene = SpriteLibraryScene(size: CGSize(width: 480 * 2, height: 270 * 2))
        scene.spritePreviewModels = selectedProject.assets
        scene.scaleMode = .aspectFit
        scene.actionPublisher
            .sink { [weak self] in self?.actionSubject.send($0) }
            .store(in: &cancellables)
        return scene 
    }()
}
