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
import Pages

class MineViewController: ItemsViewController {
    let topseg = UISegmentedControl(items: [NSLocalizedString("Favorites",  comment: "Favorites"), NSLocalizedString("History", comment:"History")])
    var defaultSegmentIndex = 0
    
    let emptyNode = EmptyNode()
    
    convenience init(segmentIndex:Int) {
        self.init()
        defaultSegmentIndex = segmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Mine", comment: "Mine")
        topseg.frame = CGRect(x: 0, y: 0, width: 180, height: 30)
        topseg.selectedSegmentIndex = defaultSegmentIndex
        topseg.addTarget(self, action: #selector(MineViewController.segmentChanged(sender:)), for: .valueChanged)
        self.navigationItem.titleView = topseg
        
        emptyNode.openButton.addTarget(self, action: #selector(self.howtoAction), forControlEvents: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        emptyNode.frame = self.view.bounds
    }
    
    override func getItems() {
        if topseg.selectedSegmentIndex == 0 {
            items = Item.mineItems()
        }else {
            items = Item.allItems()
        }
        if items!.count <= 0 {
            //show empty node
            emptyNode.frame = self.view.bounds
            view.addSubnode(emptyNode)
        }else {
            emptyNode.removeFromSupernode()
        }
        tableNode.reloadData()
    }
    
    func segmentChanged(sender:UISegmentedControl) {
        getItems()
    }
    
    func howtoAction() {
        let viewControllers = [
            UIStoryboard(name: "UsagePages", bundle: nil).instantiateViewController(withIdentifier: "usage1"),
            UIStoryboard(name: "UsagePages", bundle: nil).instantiateViewController(withIdentifier: "usage2")
        ]
        let vc = PagesController(viewControllers)
        vc.title = "Usage Guide"
        vc.enableSwipe = true
        vc.showBottomLine = true
        vc.showPageControl = true
        vc.hidesBottomBarWhenPushed = true
        vc.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(vc, animated: true)
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

extension ItemsViewController: ASTableDataSource, ASTableDelegate, UITableViewDelegate {
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
            cell.neverShowPlaceholders = true
            
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
    
    func tableNode(_ tableNode: ASTableNode, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items![indexPath.row]
            item.remove()
            getItems()
        }
    }
}
