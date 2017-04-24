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
import RealmSwift

class ActionViewController: UIViewController {

    @IBOutlet weak var emptyMessageLabel: UILabel!
    
    @IBOutlet weak var localNavigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    var productNode:ProductNode! = ProductNode()

    var spinner:JHSpinnerView!
    var triedCount:Int = 0
    
    var asin:String?
    var item:Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Realm.Configuration.defaultConfiguration = PRConfig.realmConfig()
        
        self.title = "Price Bot"
        
        addNavigationBarItem()
        PRConfig.setupUI()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.prBlack()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15)!]
        
        setNeedsStatusBarAppearanceUpdate()
        
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        self.loadNavigationItems()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.productNode.frame = CGRect(x: 0, y: 0, width: size.width, height: self.productNode.heightOfContents())
            self.scrollView.contentSize = CGSize(width: size.width, height: self.productNode.heightOfContents())
        })
    }
    
    func addNavigationBarItem() {
        let rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightBtn.setImage(UIImage(named: "share"), for: UIControlState())
        rightBtn.addTarget(self, action: #selector(self.shareAction(_:)), for: UIControlEvents.touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        let spacerRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacerRight.width = -5
        
        self.navigationItem.rightBarButtonItems = [spacerRight, rightItem]
        
    }
    
    func loadNavigationItems() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named:"close-icon"), for: .normal)
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
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
        Item.requestWithUrl(url:url) { (item:Item?) in
            
            if item != nil && item!.asin != "" {
                self.asin = item!.asin
                let founded = Item.find(byId: item!.asin)
                if founded != nil {
                    self.bindItem(founded!)
                    self.spinner.dismiss()
                    return
                }
                
                if item!.title != "" {
                    //self.title = item!.title
                    item!.save()
                    self.bindItem(item!)
                    self.spinner.dismiss()
                }else {
                    //self.title = "Loading"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.waitingItem(item!.asin)
                    }
                }
                
            }else {
                self.emptyMessageLabel.isHidden = false
                self.spinner.dismiss()
            }
            
        }
    }
    
    //TODO https://faye.jcoglan.com 改成pub/sub方式
    func waitingItem(_ p:String) {
        triedCount += 1
        print("Trying \(triedCount).")
        Item.requestWithId(p:p, handler: { (item:Item?) in
            if item == nil {
                //TODO to handle fatal error
                self.spinner.dismiss()
                self.emptyMessageLabel.text = "Unknown error occurred. please try again later."
                self.emptyMessageLabel.isHidden = false
                return
            }

            if item!.title == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.waitingItem(item!.asin)
                }
                return
            }
            item!.save()
            //self.title = item!.title
            self.bindItem(item!)
            self.spinner.dismiss()
        })
    }
    
    func bindItem(_ item:Item) {
        
        self.productNode.bindItem(item)
        //self.productNode.setNeedsLayout()
        self.productNode.priceNode.saveButton.addTarget(self, action: #selector(ActionViewController.saveItemAction(_:)), forControlEvents: .touchUpInside)
        self.item = item
        Price.requestHistoryWithId(p: item.asin) { (items:[Price]) in
            self.productNode.trendingNode.bind(items)
        }
    }
    
    func saveItemAction(_ sender:ASButtonNode) {
        if self.asin == nil {
            //error handling
            return
        }
        sender.isSelected = !sender.isSelected
        if let item = Item.find(byId: self.asin!) {
            item.saveTracking(tracking: sender.isSelected)
            print("save action")
        }
        
    }

    @IBAction func closeAction() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        //let item = Item.find(byId: asin!)
        //let realm = try! Realm()
        //print(realm.objects(Item.self))
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    func shareAction(_ sender:UIButton) {
        if item == nil {
            return
        }
        
        guard let url = URL(string:item!.url) else {
            return
        }
        let urlToShare = [ item!.title, url ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = sender
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
