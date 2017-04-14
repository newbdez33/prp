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

struct Item: Decodable {
    var asin:String
    var photo:String?
    var title:String?
    var currency:String?
    var price:Float?
    var highest:Float?
    var lowest:Float?
    
    init?(json: JSON) {
        guard let responseId: String = "asin" <~~ json else {
            return nil
        }
        
        asin        = responseId
        photo       = "photo" <~~ json
        title       = "title" <~~ json
        currency    = "currency" <~~ json
        if let priceRaw: NSString = "price" <~~ json {
            price = priceRaw.floatValue
        }else {
            price = 0
        }
        
        if let priceRaw: NSString = "highest" <~~ json {
            highest = priceRaw.floatValue
        }else {
            highest = 0
        }
        
        if let priceRaw: NSString = "lowest" <~~ json {
            lowest = priceRaw.floatValue
        }else {
            lowest = 0
        }
        
    }
}

extension Item {
    static func requestData(_ url:URL, handler:@escaping (_ item:Item?) -> ()) {
        Alamofire.request("http://api.pricebot.salmonapps.com/p", method: .post, parameters: ["url":url.absoluteString]).responseJSON { response in
            guard let json = response.result.value as? JSON else {
                return handler(nil)
            }
            handler(Item(json: json))
        }
    }
    
    static func requestData(_ p:String, handler:@escaping (_ item:Item?) -> ()) {
        Alamofire.request("http://api.pricebot.salmonapps.com/p/\(p)", method: .get, parameters: [:]).responseJSON { response in
            guard let json = response.result.value as? JSON else {
                return handler(nil)
            }
            handler(Item(json: json))
        }
    }
}
