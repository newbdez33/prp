//
//  Me.swift
//  pr
//
//  Created by JackyZ on 2017/04/30.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import OneStore

enum Me {
    static let dropNotification = OneStore<Bool>("price.drop.notification", stack: Me.stack)
    private static let stack = Stack(userDefaults: UserDefaults.standard, namespace: "me")
}
