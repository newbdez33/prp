//
//  Price.swift
//  pr
//
//  Created by JackyZ on 2017/04/20.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import Gloss
import RealmSwift
import Alamofire

class Price: Object {
    dynamic var asin:String = ""
    dynamic var currency:String = ""
    dynamic var price:Float = 0
    dynamic var t:Int = 0
    
    override public static func primaryKey() -> String? {
        return "asin"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        asin        = "asin" <~~ json ?? ""
        t           = "t" <~~ json ?? 0
        currency    = "currency" <~~ json ?? ""
        price       = "price" <~~ json ?? 0
                
    }
}

extension Price {
    static func requestHistoryWithId(p:String, handler:@escaping (_ items:[Price]) -> ()) {
        Alamofire.request("http://api.pricebot.salmonapps.com/h/\(p)", method: .get, parameters: [:]).responseJSON { response in
            guard let json = response.result.value as? [JSON] else {
                return handler([])
            }
            var ret:[Price] = []
            for j in json {
                ret.append(Price(json:j))
            }
            handler(ret)
        }
    }
}
