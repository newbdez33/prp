//
//  ActionViewController.swift
//  urlaction
//
//  Created by JackyZ on 2017/04/03.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var emptyMessageLabel: UILabel!
    
    @IBOutlet weak var localNavigationBar: UINavigationBar!
    var productView:ProductNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.loadNavigationItems()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath);

        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
                print(provider)
                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (coding:NSSecureCoding?, error:Error!) in
                        let url = coding as! URL
                        DispatchQueue.main.async {
                            self.loadProductView(url: url);
                        }
                    })
                    break
                }
            }
        }
    }
    
    func loadNavigationItems() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named:"close-icon"), for: .normal)
        closeButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        self.navigationItem.setLeftBarButtonItems([closeItem], animated: false)
    }
    
    func loadProductView(url:URL) {
        emptyMessageLabel.isHidden = true
        //API
        productView = ProductNode()
        productView.frame = self.view.bounds
        productView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubnode(productView)
        //self.view.sendSubview(toBack: productView.view)
        
        // fetch url
        Item.requestData(url) { (item:Item?) in
            print("item:\(String(describing: item))")
            self.productView.titleLabel.attributedText = ProductNode.getTitleString(string: String(describing: item))
        }
    }
    

    @IBAction func closeAction() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
