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
        self.scrollNode.automaticallyManagesContentSize = true
        self.view.backgroundColor = UIColor.white
        scrollNode.style.preferredSize = self.view.frame.size
        self.view.addSubnode(scrollNode)
        loadProductView()
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

}
