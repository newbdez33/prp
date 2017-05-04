//
//  SettingsViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import UserNotifications
import Eureka
import MessageUI

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        form +++
            Section() {
                $0.header = HeaderFooterView<PRLogoView>(.class)
            }
            +++
            Section("PRICE DROP NOTIFICATION")
            <<<
            SwitchRow("Price drop notification") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.textLabel?.textColor = UIColor.prBlack()
                $0.value = Me.dropNotification.value
                }.onChange { row in
                
                if row.value == true {
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { (settings) in
                        if settings.authorizationStatus != .authorized {
                            
                            //TODO show a nice dialog to user to accpet a notification alert
                            center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { (granted:Bool, error:Error?) in
                                if granted == true {
                                    Me.dropNotification.value = true
                                }else {
                                    
                                    Me.dropNotification.value = false
                                    DispatchQueue.main.async { [weak self] in
                                        row.value = false
                                        row.cell.switchControl?.isOn = false
                                        row.updateCell()
                                        
                                        //TODO Replace with a nice dialog
                                        let alert = UIAlertController(title: "Please enable app notification", message: "Go to iOS Settings > Notifications > Price Bot > Allow Notifications to Enable app notifications.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self?.present(alert, animated: true, completion: nil)
                                    }
                                }
                            })

                        }else {
                            //already authorized.
                            Me.dropNotification.value = true
                        }
                    }
                }else {
                    Me.dropNotification.value = row.value
                }
            }
            +++
            Section("USE PRICE BOT")
            <<< ButtonRow("How to use it") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.textLabel?.textColor = UIColor.prBlack()
                $0.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                    return HowtoViewController()
                }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
            }
            <<< ButtonRow("URL Schemes") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.textLabel?.textColor = UIColor.prBlack()
                $0.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                    return URLSchemesViewController()
                }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
            }
            +++
            Section("MISC")
            <<< ButtonRow("Recommend Price Bot") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
            }.onCellSelection({ (cell, row) in
                self.shareAction()
            })
            <<< ButtonRow("Rate on App Store") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
            }.onCellSelection({ (cell, row) in
                UIApplication.shared.open(URL(string: PRConfig.rateOnAppStoreURL)!, options: [:], completionHandler: { (success:Bool) in
                    //
                })
            })
            <<< ButtonRow("Give us feedback") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
            }.onCellSelection({ [weak self] (cell, row) in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["newbdez33+pricebot.feedback@gmail.com"])
                    mail.setSubject("Price Bot Feedback")
                    mail.setMessageBody("", isHTML: false)  //TODO Log file sending
                    
                    self?.present(mail, animated: true)
                } else {
                    // show failure alert
                }
            })
            <<< ButtonRow("Visit our website") {
                $0.title = $0.tag
                $0.cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
                $0.cell.tintColor = UIColor.prBlack()
                }.onCellSelection({ (cell, row) in
                    UIApplication.shared.open(URL(string: "http://www.salmonapps.com/#pricebot")!, options: [:], completionHandler: { (success:Bool) in
                        //
                    })
                })
            +++
            Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIView>(.callback({
                        let view = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                        let short = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
                        let bundle = Bundle.main.infoDictionary!["CFBundleVersion"]
                        view.text = "Price Bot Version \(short!) (build \(bundle!))"
                        view.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
                        view.textColor = UIColor.prGray()
                        view.textAlignment = .center
                        view.backgroundColor = .clear
                        return view
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
    }
    
    func shareAction() {

        let url = URL(string:PRConfig.appStoreURL)
        let urlToShare = [ UIApplication.shared.icon!, "Price Bot - Amazon price tracking tool!", url! ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

}

extension SettingsViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

class PRLogoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "pr-banner"))
        imageView.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        imageView.autoresizingMask = .flexibleWidth
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
