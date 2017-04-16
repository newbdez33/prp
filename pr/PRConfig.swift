//
//  PRConfig.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import RealmSwift

let realmQueue = DispatchQueue(label: "com.podbean.realmQueue");

struct PRConfig {
    static let appGroupID: String = "group.com.salmonapps.app.pr"
    
    static func realmConfig() -> Realm.Configuration {
        // 默认将 Realm 放在 App Group 里
        let directory:URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: PRConfig.appGroupID)!
        let realmPath = directory.appendingPathComponent("db.realm")
        var config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            
        })
        
        config.fileURL = realmPath
        
        return config
    }

}
