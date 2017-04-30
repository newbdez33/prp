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
            SwitchRow("Price drop notification") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.textLabel?.textColor = UIColor.prBlack()
            }.onChange { row in
                Me.dropNotification.value = row.value
            }
            +++
            Section("USE PRICE BOT")
            <<< ButtonRow("How to use it") { row in
                row.title = row.tag
            }
            <<< ButtonRow("URL Schemes") { row in
                row.title = row.tag
            }
            +++
            Section("MISC")
            <<< ButtonRow("Recommend Price Bot") { row in
                row.title = row.tag
            }
            <<< ButtonRow("Rate on App Store") { row in
                row.title = row.tag
            }
            <<< ButtonRow("Give us feedback") { row in
                row.title = row.tag
            }
            <<< ButtonRow("Visit our website") { row in
                row.title = row.tag
            }
            +++
            Section(footer: "Version 0.1(1)")
    }

}
