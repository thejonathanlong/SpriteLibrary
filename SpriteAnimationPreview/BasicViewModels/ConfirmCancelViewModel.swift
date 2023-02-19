//
//  ConfirmCancelViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/31/23.
//

import UIKit

struct ConfirmCancelViewModel {
    let title: String
    
    let message: String

    let dismissActionTitle: String

    let deleteActionTitle: String
    
    let storyName: String

    weak var store: AppStore?

    init(title: String,
         message: String,
         dismissActionTitle: String,
         deleteActionTitle: String,
         storyName: String,
         store: AppStore? = nil) {
        self.title = title
        self.message = message
        self.dismissActionTitle = dismissActionTitle
        self.deleteActionTitle = deleteActionTitle
        self.store = store
        self.storyName = storyName
    }

    func handleDelete(viewController: UIViewController?, completion: @escaping () -> Void) {
//        store?.dispatch(.storyCreation(.cancelAndDeleteCurrentStory(storyName, {
//            viewController?.dismiss(animated: true, completion: completion)
//        })))
    }

    func dismiss(viewController: UIViewController?) {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
