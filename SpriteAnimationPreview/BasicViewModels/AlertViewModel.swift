//
//  AlertViewModel.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 1/31/23.
//

import UIKit

enum AlertViewModel {
    case message(title: String, message: String, actions: [UIAlertAction])
    case input(title: String, message: String, defaultText: String, actions: [AlertAction])
}

enum AlertAction {
    case ok(alertHandler: (UIAlertController) -> Void)
    case cancel(alertHandler: (UIAlertController) -> Void)
    
    var title: String {
        switch self {
            case .ok:
                return "Ok"
            case .cancel:
                return "Cancel"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
            case .ok:
                return .default
            case .cancel:
                return .cancel
        }
    }
    
    var alertHandler: (UIAlertController) -> Void {
        switch self {
            case .ok(let alertHandler):
                return alertHandler
            case .cancel(let alertHandler):
                return alertHandler
        }
    }
}
