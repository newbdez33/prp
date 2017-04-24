//
//  ProductViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/19.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import JHSpinner
import AsyncDisplayKit
import RealmSwift
import TUSafariActivity

class ProductViewController: UIViewController {

    var scrollNode = ASScrollNode()
    var productNode:ProductNode! = ProductNode()
    
    var spinner:JHSpinnerView!
    var triedCount:Int = 0
    
    var item:Item!
    
    convenience init(_ item:Item) {
        self.init()
        self.item = item
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarItem()
        self.scrollNode.automaticallyManagesContentSize = true
        self.view.backgroundColor = UIColor.white
        scrollNode.style.preferredSize = self.view.frame.size
        self.view.addSubnode(scrollNode)
        loadProductView()
    }
    
    func addNavigationBarItem() {
        let rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        rightBtn.setImage(UIImage(named: "share"), for: UIControlState())
        rightBtn.addTarget(self, action: #selector(ProductViewController.shareAction(_:)), for: UIControlEvents.touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        let spacerRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacerRight.width = -5
        
        self.navigationItem.rightBarButtonItems = [spacerRight, rightItem]

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.resizeNodes(size:size)
        })
    }
    
    func resizeNodes(size:CGSize) {
        self.scrollNode.frame = self.view.bounds
        self.productNode.frame = CGRect(x: 0, y: 0, width: size.width, height: self.productNode.heightOfContents())
        //self.scrollNode.contentSize = CGSize(width: size.width, height: self.productNode.heightOfContents())
    }
    
    func loadProductView() {
        //API
        resizeNodes(size:self.view.frame.size)
        scrollNode.addSubnode(productNode)
        self.bindItem()

        Price.requestHistoryWithId(p: item.asin) { (items:[Price]) in
            //TODO only return extra items
            self.productNode.trendingNode.updateChart(items)
        }
    }
    
    func bindItem() {
        
        self.productNode.bindItem(item)
        //self.productNode.setNeedsLayout()
        self.productNode.priceNode.saveButton.addTarget(self, action: #selector(ProductViewController.saveItemAction(_:)), forControlEvents: .touchUpInside)
        var prices:[Price] = []
        for p in item.history {
            prices.append(p)
        }
        self.productNode.trendingNode.bind(prices)
    }
    
    func saveItemAction(_ sender:ASButtonNode) {
        sender.isSelected = !sender.isSelected
        item.saveTracking(tracking: sender.isSelected)
    }

    func shareAction(_ sender:UIButton) {
        if item == nil {
            return
        }
        
        guard let url = URL(string:item.url) else {
            return
        }
        let urlToShare = [ item.title, url ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: [TUSafariActivity()])
        activityViewController.popoverPresentationController?.sourceView = sender
        self.present(activityViewController, animated: true, completion: nil)
    }
}
