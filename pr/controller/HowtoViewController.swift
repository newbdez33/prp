//
//  HowtoViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/30.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit

class HowtoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        view.backgroundColor = UIColor.white
        if UIApplication.shared.canOpenURL(NSURL(string: "com.amazon.mobile.shopping://")! as URL) {
            print("YES")
        }else {
            print("NO")
        }
    }

}
