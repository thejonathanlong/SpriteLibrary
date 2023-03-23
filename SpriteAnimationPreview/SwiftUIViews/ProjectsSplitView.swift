//
//  ProjectsSplitView.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/21/23.
//

import Combine
import SwiftUI

protocol AddProjectHandler {
    
}

struct ProjectsSplitView: View {
    @ObservedObject var projectListViewModel: ProjectListViewModel

    var body: some View {
        NavigationSplitView() {
            NavigationLink {
                SpriteProjectDetailsView(detailsViewModel: projectListViewModel.selectedProjectModel ?? SpriteProjectDetailsViewModel(selectedProject: nil, spriteProvider: Empty<[SpritePreviewModel], Never>().eraseToAnyPublisher()))
            } label: {
                ProjectList(projectListViewModel: projectListViewModel)
                    .toolbar {
                        HStack {
                            Button {
                                projectListViewModel.addProject()
                            } label: {
                                Image(systemName: "plus.square.fill")
                                    .font(.title2)
                            }
                        }
                    }
            }
        } detail: {
            SpriteProjectDetailsView(detailsViewModel: projectListViewModel.selectedProjectModel ?? SpriteProjectDetailsViewModel(selectedProject: nil, spriteProvider: Empty<[SpritePreviewModel], Never>().eraseToAnyPublisher()))
        }
    }
}

//TODO: Need a mockDataService to make these previews work.
//struct ProjectsSplitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectsSplitView()
//    }
//}
