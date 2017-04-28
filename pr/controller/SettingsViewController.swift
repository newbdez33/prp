//
//  SettingsViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        form +++
            Section("PRICE DROP NOTIFICATION")
            <<<
            SwitchRow("Enable price drop notification") {
                $0.title = $0.tag
            }.onChange { [weak self] row in
                    //
            }
    }

}
