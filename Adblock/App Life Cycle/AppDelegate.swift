//
//  AppDelegate.swift
//  Security Manager
//
//  Created by Alexey Voronov on 16.08.2021.
// TextColor

import UIKit
import Purchases

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Purchases.logLevel = .debug
//        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: Constants.revenueAPIKey)
//        if let firstOpen = UserDefaults.standard.object(forKey: "FirstOpen") as? Date {
//            print("The app was first opened on \(firstOpen)")
//        } else {
//            // This is the first launch
//            UserDefaults.standard.set(Date(), forKey: "FirstOpen")
//        }
        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

