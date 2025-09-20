//
//  AppDelegate.swift
//  QRScanner
//
//  Created by George Popkich on 15.07.24.
//

import UIKit
import Adapty


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        application.shortcutItems = []
        application.shortcutItems?.append(ShortcutManager.sharedInstance.shortcutItem())
        //MARK: - Review
//        Adapty.logLevel = .verbose
//        Adapty.activate(Constants.Adapty.adaptyKEY)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting
                     connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, 
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {  }


}

