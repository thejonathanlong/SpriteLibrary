//
//  SpriteProjectDetailsView.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 2/19/23.
//

import SpriteKit
import SwiftUI

struct SpriteProjectDetailsView: View {

    let detailsViewModel: SpriteProjectDetailsViewModel
    
    var body: some View {
        SpriteView(scene: detailsViewModel.scene)
    }
}

//struct SpriteProjectDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpriteProjectDetailsView()
//    }
//}
