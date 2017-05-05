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
        registerPriceChangedNotification()
        
        //handle url scheme
        NavigationMap.initialize()
        if let URL = launchOptions?[.url] as? URL {
            if Navigator.open(URL) {
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
        
        completionHandler(.noData)
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func registerPriceChangedNotification() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PRICE_UPDATED"), object: nil, queue: nil) { (noti) in
            
            if Me.dropNotification.value == false {
                return
            }
            
            guard let item = noti.object as? Item else {
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "Price has dropped to \(item.price)."
            content.body = "\(item.title) new price: \(item.price)"
            content.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier: item.asin, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                if error != nil {
                    print("sending location notification error:\(String(describing: error))")
                }
            }
        }
        
    }
    
    // - MARK: Notification task
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notification received.")
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
