//
//  Router.swift
//  LonesomeDove
//  Created on 10/22/21.
//

import Foundation
import os
import SwiftUIFoundation
import UIKit
import UniformTypeIdentifiers

typealias DismissViewControllerHandler = (() -> Void)?

enum Route {
    case alert(AlertViewModel, DismissViewControllerHandler)
    case confirmCancelAlert(ConfirmCancelViewModel)
    case dismissPresentedViewController(DismissViewControllerHandler)
    case loading
    case warning(Warning)
    case documentPicker(documentSelectionHandler: (([URL]) -> Void)?)
//    case showProjectDetails(project: SpriteBookModel)

    enum Warning {
    }
}

protocol RouteController {
    var rootViewController: UIViewController? { get set }
    func route(to destination: Route)
}

public class Router: NSObject, RouteController, UIDocumentPickerDelegate {

    static let shared = Router()

    var rootViewController: UIViewController?

    private var logger = Logger(subsystem: "com.LonesomeDove.Router", category: "LonesomeDove")
    
    private var currentRouteStack: [Route] = []
    
    private var documentedSelected: (([URL]) -> Void)?

    func route(to destination: Route) {
        switch destination {
            case .confirmCancelAlert(let viewModel):
                showAlert(viewModel: viewModel)

            case .dismissPresentedViewController(let completion):
                // Pop twice because we are always pushing
                _ = currentRouteStack.popLast()
                rootViewController?.presentedViewController?.dismiss(animated: true, completion: completion)

            case .alert(let viewModel, let completion):
                showAlert(viewModel: viewModel, completion: completion)

            case .loading:
                break

            case .warning(let warning):
                break
            
            case .documentPicker(let documentSelectionHandler):
                showDocumentPicker(documentsSelected: documentSelectionHandler)
                
//            case .showProjectDetails(let project):
//                showProjectDetails(for: project)
        }
        
        currentRouteStack.append(destination)
    }
}

// MARK: - Private
private extension Router {

    func showAlert(viewModel: ConfirmCancelViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.dismissActionTitle, style: .cancel, handler: { [weak alert] _ in
            viewModel.dismiss(viewController: alert)
        }))
        alert.addAction(UIAlertAction(title: viewModel.deleteActionTitle, style: .destructive, handler: { [weak alert] _ in
            viewModel.handleDelete(viewController: alert) { [weak self] in
                self?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            }
        }))
        rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
    }

    func showAlert(viewModel: AlertViewModel, completion: (() -> Void)?) {
        let alert: UIAlertController
        switch viewModel {
            case .message(let title, let message, let actions):
                alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                actions.forEach {
                    alert.addAction($0)
                }
                
            case .input(let title, let message, let defaultText, let actions):
                alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addTextField {
                    $0.text = defaultText
                }
                actions.forEach { action in
                    let actuallyAnAction = UIAlertAction(title: action.title, style: action.style) { _ in
                        action.alertHandler(alert)
                    }
                    alert.addAction(actuallyAnAction)
                }
        }
        
        let presentingViewController = rootViewController?.presentedViewController ?? rootViewController
        presentingViewController?.present(alert, animated: true, completion: completion)
    }
    
    func showShareSheet(for url: URL?) {
        let activityViewController = UIActivityViewController(activityItems: [url].compactMap { $0 }, applicationActivities: nil)
        let navigationController = UINavigationController(rootViewController: activityViewController)
        
        let presentingViewController = rootViewController?.presentedViewController ?? rootViewController
        navigationController.popoverPresentationController?.sourceView = presentingViewController?.view
        
        presentingViewController?.popoverPresentationController?.sourceView = presentingViewController?.view
        presentingViewController?.present(navigationController, animated: true)
    }
    
    func showDocumentPicker(documentsSelected: (([URL]) -> Void)?) {
        self.documentedSelected = documentsSelected
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.png, UTType.gif])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        let presentingViewController = rootViewController?.presentedViewController ?? rootViewController
        presentingViewController?.present(documentPicker, animated: true)
    }
    
    
    
    func showProjectDetails(for project: SpriteProjectModel) {
        
    }
}

public extension Router {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        documentedSelected?(urls)
    }
}
