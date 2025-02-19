//
//  AppDelegate.swift
//  Movies-Task
//
//  Created by Mostafa on 18/02/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let injectionContainer = HomeDependencyContainer()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainVC = injectionContainer.makeHomeViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
        return true
    }
}

