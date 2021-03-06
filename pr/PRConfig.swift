//
//  PRConfig.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import RealmSwift

let realmQueue = DispatchQueue(label: "com.salmonapps.pricebot.realmQueue");

struct PRConfig {
    static let appGroupID: String = "group.com.salmonapps.app.pr"
    static let appStoreURL: String = "https://itunes.apple.com/app/id1231974655"
    static let rateOnAppStoreURL: String = "itms-apps://itunes.apple.com/app/id1231974655?action=write-review"
    static let updateInterval: TimeInterval = 60    //每分钟
    static func realmConfig() -> Realm.Configuration {
        // 默认将 Realm 放在 App Group 里
        let directory:URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: PRConfig.appGroupID)!
        let realmPath = directory.appendingPathComponent("db.realm")
        var config = Realm.Configuration(schemaVersion: 4, migrationBlock: { migration, oldSchemaVersion in
            
        })
        
        config.fileURL = realmPath
        
        return config
    }
    
    static func setupUI() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.prDefault(size: 15), NSForegroundColorAttributeName:UIColor.prBlack()]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.prBlack()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "back")!, for: .normal, barMetrics: .default)
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.prGray()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.prBlack()
    }

}
