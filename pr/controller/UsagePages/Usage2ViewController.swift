//
//  Usage2ViewController.swift
//  pr
//
//  Created by JackyZ on 2017/05/15.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit

class Usage2ViewController: UIViewController {
    
    @IBOutlet weak var openButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Everything is here! Open Amazon site now
        let attrString = NSMutableAttributedString(string: NSLocalizedString("Everything is here! ", comment: ""),
                                                   attributes: [ NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size:14)! ])
        
        attrString.append(NSMutableAttributedString(string: NSLocalizedString("Open Amazon site now", comment: ""),
                                                    attributes: [NSFontAttributeName: UIFont(name:"HelveticaNeue-Bold", size:14)! ]))
        openButton.setAttributedTitle(attrString, for: .normal)
    }
    
    
    @IBAction func openAction(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("We are currently support those sites.", comment: ""), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "amazon.com", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string:"http://amazon.com")!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "amazon.cn", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string:"http://amazon.cn")!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "amazon.co.jp", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string:"http://amazon.co.jp")!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "amazon.de", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string:"http://amazon.de")!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.bounds
        present(alert, animated: true, completion: nil)
    }

}
