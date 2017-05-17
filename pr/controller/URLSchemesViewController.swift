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
            Section(NSLocalizedString("SELECT TO COPY URL SCHEME", comment: ""))
            <<< LabelRow(NSLocalizedString("Show History List", comment: "")) {
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
            <<< LabelRow(NSLocalizedString("Show Favorites List", comment: "")) {
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
                    CRNotifications.showNotification(type: .info, title: NSLocalizedString("URL Scheme Copied", comment: ""), message: url, dismissDelay: 1)
                })
            <<< LabelRow(NSLocalizedString("Show Product Activity", comment: "")) {
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
                    CRNotifications.showNotification(type: .info, title: NSLocalizedString("URL Scheme Copied", comment: ""), message: url, dismissDelay: 1)
                })
            //TODO pricebot://activity?url=
    }

}
