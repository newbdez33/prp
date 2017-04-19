//
//  HistoryViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit

class HistoryViewController: ItemsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
    }
    
    override func getItems() {
        items = Item.allItems()
    }

}
