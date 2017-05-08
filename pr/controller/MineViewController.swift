//
//  MineViewController.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import RealmSwift
import AsyncDisplayKit
import TUSafariActivity

class MineViewController: ItemsViewController {
    let topseg = UISegmentedControl(items: ["Favorites", "History"])
    var defaultSegmentIndex = 0
    
    convenience init(segmentIndex:Int) {
        self.init()
        defaultSegmentIndex = segmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mine"
        topseg.selectedSegmentIndex = defaultSegmentIndex
        topseg.addTarget(self, action: #selector(MineViewController.segmentChanged(sender:)), for: .valueChanged)
        self.navigationItem.titleView = topseg
    }
    
    override func getItems() {
        if topseg.selectedSegmentIndex == 0 {
            items = Item.mineItems()
        }else {
            items = Item.allItems()
        }
        tableNode.reloadData()
    }
    
    func segmentChanged(sender:UISegmentedControl) {
        getItems()
    }
}

class ItemsViewController: UIViewController {
    
    var items:Results<Item>?
    let tableNode = ASTableNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.tableFooterView = UIView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableNode.frame = view.bounds
    }
    
    func getItems() {
        //items = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItems()
    }
    
    func infoAction(sender:ASButtonNode) {
        if items == nil {
            return
        }
        
        let buttonPosition = sender.view.convert(CGPoint.zero, to: tableNode.view)
        guard let index = tableNode.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        if index.row >= items!.count {
            return
        }
        let item = items![index.row]
        
        guard var url = URL(string:item.url) else {
            return
        }
        if let clean_url = URL(string:item.clean_url) {
            url = clean_url
        }
        let urlToShare = [ item.title, url ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: [TUSafariActivity()])
        activityViewController.popoverPresentationController?.sourceView = sender.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension ItemsViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if items == nil {
            return 0
        }
        return items!.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        guard items!.count > indexPath.row else { return { ASCellNode() } }
        
        let item = items![indexPath.row]
        let itemRef = ThreadSafeReference(to: item)
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let cellNodeBlock = { () -> ASCellNode in
            
            let cell = ItemCellNode()
            let realm = try! Realm()
            guard let item = realm.resolve(itemRef) else {
                return cell
            }
            cell.bind(item: item)
            cell.infoButton.addTarget(self, action: #selector(ItemsViewController.infoAction(sender:)), forControlEvents: .touchUpInside)
            return cell
        }
        
        return cellNodeBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let item = items![indexPath.row]
        let vc = ProductViewController(id: item.asin)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
