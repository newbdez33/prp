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
import URLNavigator
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])

        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {

            var segmentIdx = 0
            if let URL = launchOptions?[.url] as? URL {
                if URL.absoluteString == "pricebot://history" {
                    segmentIdx = 1
                }
            }
            let mineVc = UINavigationController(rootViewController: MineViewController(segmentIndex:segmentIdx))
            let settingsVc = UINavigationController(rootViewController: SettingsViewController())
            
            mineVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: NSLocalizedString("Mine", comment: "Mine"), image: UIImage(named:"star_tab"), selectedImage: UIImage(named:"star_tab"))
            settingsVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: NSLocalizedString("Settings", comment: "Settings"), image: UIImage(named:"settings_tab"), selectedImage: UIImage(named:"settings_tab"))
            
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
        
        //handle url scheme
        NavigationMap.initialize()
        if let URL = launchOptions?[.url] as? URL {
            if !Navigator.open(URL) {
                Navigator.push(URL)
            }
        }
        
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
        if Navigator.open(url) {
            NSLog("Navigator: Open \(url)")
            return true
        }
        
        if Navigator.push(url) != nil {
            return true
        }
        
        return false
    }
    
    // - MARK: Background task
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        for i in Item.allItems() {
            //let gap = Date().timeIntervalSince1970 - Double(i.updated_at)
            //if gap > 3600 {
                Item.requestWithId(p:i.asin, handler: { (item:Item?) in
                    if item == nil {
                        return
                    }
                    item!.update()
                })
            //}
        }
        
        completionHandler(.noData)
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // - MARK: Notification task
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notification received.")
        
        let userData = response.notification.request.content.userInfo
        guard let asin = userData["asin"] as? String else {
            completionHandler()
            return
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
            Navigator.push("pricebot://activity/\(asin)")
        case "detailAction":
            print("Detail Action")
            Navigator.push("pricebot://activity/\(asin)")
        case "urlAction":
            print("URL Action")
            if let urlstr = userData["url"] as? String {
                if let url = URL(string: urlstr) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        default:
            print("case Default action")
            Navigator.push("pricebot://activity/\(asin)")
        }
        
        completionHandler()
    }
    
}

extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }
        
        return icon
    }
}
