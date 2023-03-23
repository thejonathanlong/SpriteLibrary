//
//  ProjectList.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/21/23.
//

import Combine
import SwiftUI

struct ProjectList: View {
    
    @ObservedObject var projectListViewModel: ProjectListViewModel
    
    var body: some View {
        List(projectListViewModel.projects) { project in
            emptyAssetsView(project: project, isSelected: project.id == projectListViewModel.selectedProject?.id)
                .onTapGesture {
                    projectListViewModel.didSelect(project)
                }
        }
    }
    
    func emptyAssetsView(project: SpriteProjectModel, isSelected: Bool) -> some View {
        HStack {
            if let _ = project.icon {
                Spacer()
            }
            VStack {
                if let icon = project.icon {
                    Image(uiImage: icon)
                }
                Text(project.name)
            }
            if let _ = project.icon {
                Spacer()
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8.0).stroke( isSelected ? Color.red : Color.clear))
    }
    
    func disclosureGroup(project: SpriteProjectModel) -> some View {
        DisclosureGroup {
            if let assets = project.assets {
                VStack {
                    ForEach(assets) { asset in
                        HStack {
                            Spacer()
                            VStack {
                                Image(uiImage: asset.previewImage)
                                Text(asset.name)
                            }
                            Spacer()
                        }
                        .onTapGesture {
                            projectListViewModel.didSelect(asset)
                        }
                    }
                }
            }
        } label: {
            HStack {
                if let _ = project.icon {
                    Spacer()
                }
                VStack {
                    if let icon = project.icon {
                        Image(uiImage: icon)
                    }
                    Text(project.name)
                }
                if let _ = project.icon {
                    Spacer()
                }
            }
        }
    }
}


//TODO: Make a MockDataService to make this Preview work.
//struct ProjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectList(projectListViewModel: ProjectListViewModel(projects: [
//            AssetViewModel(name: "Hello", icon: nil, assets: [
//                AssetViewModel(name: "a", icon: UIImage(systemName: "pencil")!)
//            ]),
//
//            AssetViewModel(name: "Goodbye", icon: nil, assets: [
//                AssetViewModel(name: "b", icon: UIImage(systemName: "pencil")!)
//            ]),
//            AssetViewModel(name: "Rect", icon: nil, assets: [
//                AssetViewModel(name: "b", icon: UIImage(named: "Bordered_Rectangle")!),
//                AssetViewModel(name: "b", icon: UIImage(named: "Bordered_Rectangle")!),
//                AssetViewModel(name: "b", icon: UIImage(named: "Bordered_Rectangle")!),
//                AssetViewModel(name: "b", icon: UIImage(named: "Bordered_Rectangle")!),
//                AssetViewModel(name: "b", icon: UIImage(named: "Bordered_Rectangle")!),
//                AssetViewModel(name: "b", icon: UIImage(named: "Bordered_Rectangle")!)
//            ])
//        ]))
//    }
//}
