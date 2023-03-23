//
//  SpriteProjectDetailsViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 2/19/23.
//

import Combine
import SwiftUI

protocol SpriteProviderInterface {
    func provider(for projectId: String) -> AnyPublisher<[SpritePreviewModel], Never>
}

class SpriteProjectDetailsViewModel: ObservableObject {
    var selectedProject: SpriteProjectModel?
    
    private var actionSubject = PassthroughSubject<SpriteLibraryScene.Action, Never>()
    
    lazy var actionPublisher: AnyPublisher<SpriteLibraryScene.Action, Never> = actionSubject.eraseToAnyPublisher()
    
    var cancellables = Set<AnyCancellable>()

    struct Constants {
        static var size = CGSize(width: 560 * 2, height: 315 * 2)
    }

    @Published var scene: SpriteLibraryScene?
    
    init(selectedProject: SpriteProjectModel?, spriteProvider: AnyPublisher<[SpritePreviewModel], Never>) {
        self.selectedProject = selectedProject

        let scene = SpriteLibraryScene(size: Constants.size)
        scene.spritePreviewModels = selectedProject?.assets ?? []
        scene.scaleMode = .aspectFit
        self.scene = scene

        spriteProvider
            .sink { [weak self] previewModels in
                guard let self, !previewModels.isEmpty else { return }
                self.selectedProject?.update(newAssets: previewModels)
                self.scene?.spritePreviewModels = previewModels
            }
            .store(in: &cancellables)

        scene.actionPublisher
            .sink { [weak self] in self?.actionSubject.send($0) }
            .store(in: &cancellables)
    }
}
