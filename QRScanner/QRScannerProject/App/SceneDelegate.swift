//
//  SceneDelegate.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let container = ContainerRegistrator.makeContainer()
        container.register({ WindowManager(scene: windowScene) })
        appCoordinator = AppCoordinator(container: container)
        appCoordinator?.showLaunchScreen()
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(
            ShortcutManager
                .sharedInstance
                .handle(shortcutItem: shortcutItem,
                        rootVC: windowScene.keyWindow?.rootViewController)
        )
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        appCoordinator?.startFromForeground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
