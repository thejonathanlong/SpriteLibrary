//
//  SpriteProjectDetailsView.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 2/19/23.
//

import SpriteKit
import SwiftUI

struct SpriteProjectDetailsView: View {
    
    lazy var spriteLibraryScene = SpriteLibraryScene(size: CGSize(width: 480 * 2, height: 270 * 2)
                                                     , spriteLibraryDelegate: self)
    
    var body: some View {
        SpriteView(scene: spriteLibraryScene)
    }
}

//struct SpriteProjectDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpriteProjectDetailsView()
//    }
//}
