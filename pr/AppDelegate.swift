//
//  AppDelegate.swift
//  pr
//
//  Created by JackyZ on 2017/04/03.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift
import ESTabBarController_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {

            let mineVc = UINavigationController(rootViewController: MineViewController())
            let settingsVc = UINavigationController(rootViewController: SettingsViewController())
            
            mineVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: "Mine", image: UIImage(named:"star_tab"), selectedImage: UIImage(named:"star_tab"))
            settingsVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: "Settings", image: UIImage(named:"settings_tab"), selectedImage: UIImage(named:"settings_tab"))
            
            let tabBarController = ESTabBarController()
            tabBarController.viewControllers = [mineVc, settingsVc]
            if let tabBar = tabBarController.tabBar as? ESTabBar {
                tabBar.itemCustomPositioning = .fillIncludeSeparator
            }
            window.rootViewController = tabBarController
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()
        }
        
        PRConfig.setupUI()
        Realm.Configuration.defaultConfiguration = PRConfig.realmConfig()
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(PRConfig.updateInterval)
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            for i in Item.allItems() {
                let gap = Date().timeIntervalSince1970 - Double(i.updated_at)
                if gap > 3600 * 12 {
                    Item.requestWithId(p:i.asin, handler: { (item:Item?) in
                        if item == nil {
                            return
                        }
                        item!.update()
                    })
                }
            }
            
        }
    }
    
    // - MARK: Handle url schemes
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //TODO
        return false
    }
    
    // - MARK: Background task
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //TODO fetch new priecs
        completionHandler(.noData)
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // - MARK: Notification task
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notification received.")
    }
    
}

