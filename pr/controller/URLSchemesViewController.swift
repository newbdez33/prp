//
//  URLSchemesViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/30.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import Eureka

class URLSchemesViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO tableView?.estimatedRowHeight = 60
        title = "URL Schemes"
        form +++
            Section("SELECT TO COPY URL SCHEME")
            <<< LabelRow("Show History List") {
                $0.title = $0.tag
                $0.cellStyle = .subtitle    //ORDER !!!
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
                $0.cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
                $0.cell.detailTextLabel?.textColor = UIColor.prGray()
                }.cellUpdate({ (cell, row) in
                    cell.detailTextLabel?.text = "pricebot://history"
                })
                .onCellSelection({ (cell, row) in
                    let url = cell.detailTextLabel?.text ?? ""
                    print(url)
                    UIPasteboard.general.string = url
                    CRNotifications.showNotification(type: .info, title: "URL Scheme Copied", message: url, dismissDelay: 1)
                })
            <<< LabelRow("Show Favorites List") {
                $0.title = $0.tag
                $0.cellStyle = .subtitle    //ORDER !!!
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
                $0.cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
                $0.cell.detailTextLabel?.textColor = UIColor.prGray()
                }.cellUpdate({ (cell, row) in
                    cell.detailTextLabel?.text = "pricebot://favorites"
                })
                .onCellSelection({ (cell, row) in
                    let url = cell.detailTextLabel?.text ?? ""
                    print(url)
                    UIPasteboard.general.string = url
                    CRNotifications.showNotification(type: .info, title: "URL Scheme Copied", message: url, dismissDelay: 1)
                })
            <<< LabelRow("Show Product Activity") {
                $0.title = $0.tag
                $0.cellStyle = .subtitle    //ORDER !!!
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
                $0.cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
                $0.cell.detailTextLabel?.textColor = UIColor.prGray()
                }.cellUpdate({ (cell, row) in
                    cell.detailTextLabel?.text = "pricebot://activity?id="
                })
                .onCellSelection({ (cell, row) in
                    let url = cell.detailTextLabel?.text ?? ""
                    print(url)
                    UIPasteboard.general.string = url
                    CRNotifications.showNotification(type: .info, title: "URL Scheme Copied", message: url, dismissDelay: 1)
                })
            //TODO pricebot://activity?url=
    }

}
