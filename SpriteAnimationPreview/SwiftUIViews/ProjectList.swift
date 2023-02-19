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
//            if project.assets.isEmpty {
                emptyAssetsView(project: project)
                .onTapGesture {
                    projectListViewModel.didSelect(project)
                }
//            } else {
//                disclosureGroup(project: project)
//
//            }
        }
    }
    
    func emptyAssetsView(project: SpriteProjectModel) -> some View {
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

struct TestData: Identifiable {
    let name: String
    let children: [ChildData]
    
    let id = UUID()
}

struct ChildData: Identifiable {
    let data: Int
    
    let id = UUID()
}

struct xyz: View {
    let data: [TestData]
    
    var body: some View {
        
        List(data) { datum in
            DisclosureGroup {
                VStack {
                    ForEach(datum.children) { child in
                        Text("\(child.data)")
                    }
                }
            } label: {
                Text(datum.name)
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

struct xyz_Previews: PreviewProvider {
    static var previews: some View {
        xyz(data: [
            TestData(name: "1",
                     children: [
                        ChildData(data: 1),
                        ChildData(data: 1),
                        ChildData(data: 1),
                        ChildData(data: 1),
                        ChildData(data: 1),
                        ChildData(data: 1),
                        ChildData(data: 1),
                        ChildData(data: 1)
                     ]),
            TestData(name: "2",
                     children: [
                        ChildData(data: 2),
                        ChildData(data: 2),
                        ChildData(data: 2),
                        ChildData(data: 2),
                        ChildData(data: 2),
                        ChildData(data: 2),
                        ChildData(data: 2),
                        ChildData(data: 2)
                     ]),
        ])
    }
    
}
