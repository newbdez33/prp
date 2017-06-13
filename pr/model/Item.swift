//
//  Item.swift
//  pr
//
//  Created by JackyZ on 2017/04/13.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import RealmSwift
import UserNotifications

class Item: Object {
    dynamic var asin:String = ""
    dynamic var photo:String = ""
    dynamic var title:String = ""
    dynamic var currency:String = ""
    dynamic var price:Float = 0
    dynamic var highest:Float = 0
    dynamic var lowest:Float = 0
    dynamic var url:String = ""
    dynamic var aac:String = ""
    dynamic var clean_url:String = ""
    dynamic var created_at:Int = 0
    dynamic var updated_at:Int = 0
    
    dynamic var added_at:Int = 0
    
    //local
    dynamic var isTracking:Bool = false
    var history = List<Price>()
    
    override public static func primaryKey() -> String? {
        return "asin"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        asin        = "asin" <~~ json ?? ""
        url         = "url" <~~ json ?? ""
        clean_url   = "clean_url" <~~ json ?? ""
        aac         = "aac" <~~ json ?? ""
        photo       = "photo" <~~ json ?? ""
        title       = "title" <~~ json ?? ""
        currency    = "currency" <~~ json ?? ""
        price       = "price" <~~ json ?? 0
        highest     = "highest" <~~ json ?? 0
        lowest      = "lowest" <~~ json ?? 0
        created_at  = "created_at" <~~ json ?? 0
        updated_at  = "updated_at" <~~ json ?? 0
        
        added_at    = Int(Date().timeIntervalSince1970)
        
    }
    
}

extension Item {
    
    class func find(byId pid:String) -> Item? {
        let realm = try! Realm()
        return realm.objects(Item.self).filter("asin = %@", pid).first
    }
    
    func add() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self)
        }
    }
    
    func remove() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func update() {
        guard let old = Item.find(byId: self.asin) else {
            return
        }
        if self.price != old.price {
            //handling Price drop
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PRICE_UPDATED"), object: self)
            
            //send local notification
            if Me.dropNotification.value == false {
                return
            }

            let detail = UNNotificationAction(identifier: "detailAction", title: NSLocalizedString("Detail",  comment: ""), options: [.foreground])
            let goUrl = UNNotificationAction(identifier: "urlAction", title: NSLocalizedString("Open Product URL",  comment: ""), options: [])
            let category = UNNotificationCategory(identifier: "ProductNotificationCategory", actions: [detail, goUrl], intentIdentifiers: [], options: [])
            /*
            let url = URL(string: self.photo)
            if url != nil {
                let attachmentIdentifier = "PhotoAttachment"
                if let attachment = try? UNNotificationAttachment(identifier: attachmentIdentifier, url: url!, options: nil) {
                    content.attachments = [attachment]
                }
            }
             */

            let content = UNMutableNotificationContent()
            content.title = "\(self.title)"
            content.body = "\(old.price) → \(self.price)"
            content.sound = UNNotificationSound.default()
            content.userInfo = ["asin":self.asin, "url":self.clean_url]
            content.categoryIdentifier = "ProductNotificationCategory"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier: self.asin, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([category])
            center.add(request) { (error) in
                if error != nil {
                    print("sending location notification error:\(String(describing: error))")
                }
            }
        }
        let realm = try! Realm()
        try! realm.write {
            old.updated_at = Int(Date().timeIntervalSince1970)
            old.price = self.price
            old.highest = self.highest
            old.lowest = self.lowest
            old.photo = self.photo
            old.title = self.title
            old.currency = self.currency
            old.aac = self.aac
            old.clean_url = self.clean_url
            old.url = self.url
        }
    }
    
    func saveTracking(tracking:Bool) {
        let realm = try! Realm()
        try! realm.write {
            self.isTracking = tracking
            //realm.add(self, update: true)
        }
    }
    
    func findLastChangedPrice() -> Float {
        if self.history.count < 2 {
            return self.price
        }
        for p in self.history.reversed() {
            if p.price != price {
                return p.price
            }
        }
        
        return price
    }
}

extension Item {
    static func requestWithUrl(url:URL, handler:@escaping (_ item:Item?) -> ()) {
        Alamofire.request("http://api.pricebot.salmonapps.com/p", method: .post, parameters: ["url":url.absoluteString]).responseJSON { response in
            guard let json = response.result.value as? JSON else {
                return handler(nil)
            }
            handler(Item(json: json))
        }
    }
    
    static func requestWithId(p:String, handler:@escaping (_ item:Item?) -> ()) {
        Alamofire.request("http://api.pricebot.salmonapps.com/p/\(p)", method: .get, parameters: [:]).responseJSON { response in
            guard let json = response.result.value as? JSON else {
                return handler(nil)
            }
            handler(Item(json: json))
        }
    }
    
    static func mineItems() -> Results<Item> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "isTracking == true")
        let result = realm.objects(Item.self).filter(predicate).sorted(byKeyPath: "added_at", ascending: false) as Results<Item>
        return result
    }
    
    static func allItems() -> Results<Item> {
        let realm = try! Realm()
        let result = realm.objects(Item.self).sorted(byKeyPath: "added_at", ascending: false)
        return result
    }
}
