//
//  AppDelegate.swift
//  pr
//
//  Created by JackyZ on 2017/04/03.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import RealmSwift
import ESTabBarController_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {

            let mineVc = UINavigationController(rootViewController: MineViewController())
            let historyVc = UINavigationController(rootViewController: HistoryViewController())
            let settingsVc = UINavigationController(rootViewController: SettingsViewController())
            
            mineVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: "Mine", image: UIImage(named:"star_tab"), selectedImage: UIImage(named:"star_tab"))
            historyVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: "History", image: UIImage(named:"history_tab"), selectedImage: UIImage(named:"history_tab"))
            settingsVc.tabBarItem = ESTabBarItem.init(PRTabbarItemView(), title: "Settings", image: UIImage(named:"settings_tab"), selectedImage: UIImage(named:"settings_tab"))
            
            let tabBarController = ESTabBarController()
            if let tabBar = tabBarController.tabBar as? ESTabBar {
                tabBar.itemCustomPositioning = .fillIncludeSeparator
            }
            tabBarController.viewControllers = [mineVc, historyVc, settingsVc]
            window.rootViewController = tabBarController
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()
        }
        
        PRConfig.setupUI()
        Realm.Configuration.defaultConfiguration = PRConfig.realmConfig()        
        return true
    }
    
    

}

