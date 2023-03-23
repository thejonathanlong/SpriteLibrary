//
//  SpriteProjectDetailsView.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 2/19/23.
//

import SpriteKit
import SwiftUI

struct SpriteProjectDetailsView: View {

    @ObservedObject var detailsViewModel: SpriteProjectDetailsViewModel

    var emptyLibraryScene: SpriteLibraryScene {
        let scene = SpriteLibraryScene(size: SpriteProjectDetailsViewModel.Constants.size, shouldShowAddNode: false)
        scene.scaleMode = .aspectFit
        return scene
    }
    
    var body: some View {
        if let scene = detailsViewModel.scene {
            SpriteView(scene: scene)
        } else {
            SpriteView(scene: emptyLibraryScene)
        }
    }
}
