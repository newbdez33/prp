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
        aac         = "aac" <~~ json ?? ""
        photo       = "photo" <~~ json ?? ""
        title       = "title" <~~ json ?? ""
        currency    = "currency" <~~ json ?? ""
        price       = "price" <~~ json ?? 0
        highest       = "highest" <~~ json ?? 0
        lowest       = "lowest" <~~ json ?? 0
        
    }
    
}

extension Item {
    
    class func find(byId pid:String) -> Item? {
        let realm = try! Realm()
        return realm.objects(Item.self).filter("asin = %@", pid).first
    }
    
    func save() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self)
        }
    }
    
    func saveTracking(tracking:Bool) {
        let realm = try! Realm()
        try! realm.write {
            self.isTracking = tracking
            realm.add(self, update: true)
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
        let result = realm.objects(Item.self).filter(predicate) as Results<Item>
        return result
    }
    
    static func allItems() -> Results<Item> {
        let realm = try! Realm()
        let result = realm.objects(Item.self)
        return result
    }
}
