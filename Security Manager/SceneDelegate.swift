//
//  SceneDelegate.swift
//  Security Manager
//
//  Created by Alexey Voronov on 16.08.2021.
//

import UIKit
import SwiftUI
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GADFullScreenContentDelegate {

    var window: UIWindow?
    let passwordManager = PasswordManager()
    @ObservedObject var passcodeManager = PasscodeManager()

    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()

    func requestAppOpenAd() {
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: Config.Ads.firstOpen,
                          request: request,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: { (appOpenAdIn, _) in
                            self.appOpenAd = appOpenAdIn
                            self.appOpenAd?.fullScreenContentDelegate = self
                            self.loadTime = Date()
                            print("Ad is ready")
                          })
    }

    func tryToPresentAd() {
        if let gOpenAd = self.appOpenAd, let rwc = self.window?.rootViewController, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            gOpenAd.present(fromRootViewController: rwc)
        } else {
            self.requestAppOpenAd()
        }
    }

    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 10.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        requestAppOpenAd()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestAppOpenAd()
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present")
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        ProductsStore.shared.initializeProducts(nil)
        
        if let windowScene = scene as? UIWindowScene {
            UITableViewCell.appearance().selectionStyle = .none
            
            window = UIWindow(windowScene: windowScene)
            
//            let mainView = MainMenuView()
            let mainView = TabBarView()
                .environmentObject(passcodeManager)


                window?.overrideUserInterfaceStyle = .dark
                
                window?.rootViewController = UIHostingController(rootView: mainView)
                
                tryToPresentAd()
            
            
            window?.makeKeyAndVisible()

        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        self.tryToPresentAd()
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

