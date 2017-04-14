//
//  ActionViewController.swift
//  urlaction
//
//  Created by JackyZ on 2017/04/03.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import MobileCoreServices
import JHSpinner
import AsyncDisplayKit

class ActionViewController: UIViewController {

    @IBOutlet weak var emptyMessageLabel: UILabel!
    
    @IBOutlet weak var localNavigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    var productNode:ProductNode! = ProductNode()
    
    var spinner:JHSpinnerView!
    var triedCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.92)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15)!]
        setNeedsStatusBarAppearanceUpdate()
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        self.loadNavigationItems()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath);

        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
                //print(provider)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.productNode.frame = CGRect(x: 0, y: 0, width: size.width, height: self.productNode.heightOfContents())
            self.scrollView.contentSize = CGSize(width: size.width, height: self.productNode.heightOfContents())
        })
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
        productNode.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: productNode.heightOfContents())
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: productNode.heightOfContents())
        scrollView.addSubnode(productNode)
        
        spinner = JHSpinnerView.showOnView(view, spinnerColor:UIColor.black.withAlphaComponent(0.92), overlay:.fullScreen, overlayColor:UIColor.clear)
        view.addSubview(spinner)
        // fetch url
        Item.requestData(url) { (item:Item?) in
            
            if item != nil {
                if item!.title != nil {
                    self.title = item!.title
                    self.productNode.bindItem(item!)
                    self.productNode.setNeedsLayout()
                    self.spinner.dismiss()
                }else {
                    self.title = "Loading"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.waitingItem(item!.asin)
                    }
                }
                
            }else {
                self.spinner.dismiss()
            }
            
        }
    }
    
    //TODO https://faye.jcoglan.com 改成pub/sub方式
    func waitingItem(_ p:String) {
        triedCount += 1
        print("Trying \(triedCount).")
        Item.requestData(p, handler: { (item:Item?) in
            if item == nil {
                //TODO to handle fatal error
                self.spinner.dismiss()
                self.emptyMessageLabel.text = "Unknown error occurred. please try again later."
                self.emptyMessageLabel.isHidden = false
                return
            }
            
            if item!.title == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.waitingItem(item!.asin)
                }
                return
            }
            print("Fetched \(item!.title ?? "")")
            self.title = item!.title
            self.productNode.bindItem(item!)
            self.spinner.dismiss()
        })
    }
    

    @IBAction func closeAction() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
