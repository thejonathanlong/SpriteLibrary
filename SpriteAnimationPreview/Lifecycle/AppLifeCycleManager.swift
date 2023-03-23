//
//  AppLifeCycleManager.swift
//  LonesomeDove
//  Created on 10/22/21.
//

import Combine
import os
import SwiftUI
import SwiftUIFoundation
import UIKit

class AppLifeCycleManager {

    static let shared = AppLifeCycleManager()

    var window: UIWindow?

    lazy var store: AppStore = AppStore(initialState: state, reducer: appReducer, middlewares: [
        dataStoreMiddleware(service: state.dataService)
    ])

    var router: RouteController
    
    lazy var storeGlue = StoreGlue(store: store)
    
    lazy var state = AppState()

    var logger = Logger(subsystem: "com.PocketPixels", category: "PocketPixels")

    init(router: RouteController = Router.shared) {
        self.router = router
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logger.log(level: .debug, "Application directory: \(NSHomeDirectory())")
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let projectListViewModel = ProjectListViewModel(spriteBookProvider: self)
        storeGlue.subscribeTo(projectListViewModel: projectListViewModel)
        let projectListViewController = HostedViewController(contentView: ProjectsSplitView(projectListViewModel: projectListViewModel))
        router.rootViewController = projectListViewController
        window?.rootViewController = projectListViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) {
        // Save changes in the application's managed object context when the application transitions to the background.
//        store?.dispatch(.dataStore(.save))
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

extension AppLifeCycleManager: SpriteCollectionProviderRequester {
    var provider: AnyPublisher<[SpriteProjectModel], Never> {
        state.dataService
            .projectDataService
            .resultPublisher
    }
    
    func requestSpriteCollections() {
        storeGlue.requestSpriteCollections()
    }
}
