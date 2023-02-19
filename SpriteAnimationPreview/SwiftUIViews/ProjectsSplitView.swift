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
        NavigationSplitView {
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
        } detail: {
            if let selectedProject = projectListViewModel.selectedProject {
                Text("\(selectedProject.name)")
            } else {
                Text("I dunno")
            }
        }
    }
}

//TODO: Need a mockDataService to make these previews work.
//struct ProjectsSplitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectsSplitView()
//    }
//}
