//
//  Usage2ViewController.swift
//  pr
//
//  Created by JackyZ on 2017/05/15.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit

class Usage2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "We are currently support those sites.", message: nil, preferredStyle: .actionSheet)
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
