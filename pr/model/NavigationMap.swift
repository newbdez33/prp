//
//  NavigationMap.swift
//  pr
//
//  Created by JackyZ on 2017/05/06.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import URLNavigator
import ESTabBarController_swift

struct NavigationMap {
    
    static func initialize() {
        Navigator.map("pricebot://activity", self.activity)
        Navigator.map("pricebot://activity/<id>", ProductViewController.self)
        Navigator.map("pricebot://history", self.history)
        Navigator.map("pricebot://favorites", self.favorites)
    }
    
    private static func activity(URL: URLConvertible, values: [String: Any]) -> Bool {
        let id = URL.queryParameters["id"]
        if id == nil || id == "" {
            return false
        }
        Navigator.push("pricebot://activity/\(id!)")
        return true
    }
    
    private static func favorites(URL: URLConvertible, values: [String: Any]) -> Bool {
        //change segment
        let app = UIApplication.shared.delegate as! AppDelegate
        let tab = app.window?.rootViewController as! ESTabBarController
        tab.selectedIndex = 0
        let nav = tab.selectedViewController as! UINavigationController
        let vc = nav.viewControllers.first as! MineViewController
        vc.topseg.selectedSegmentIndex = 0
        vc.getItems()
        return true
    }
    
    private static func history(URL: URLConvertible, values: [String: Any]) -> Bool {
        //change segment
        let app = UIApplication.shared.delegate as! AppDelegate
        let tab = app.window?.rootViewController as! ESTabBarController
        tab.selectedIndex = 0
        let nav = tab.selectedViewController as! UINavigationController
        let vc = nav.viewControllers.first as! MineViewController
        vc.topseg.selectedSegmentIndex = 1
        vc.getItems()
        return true
    }
    
}

