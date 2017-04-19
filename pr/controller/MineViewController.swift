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

class MineViewController: UIViewController {
    
    var items:Results<Item>?
    let tableNode = ASTableNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mine"
        view.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.tableFooterView = UIView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableNode.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = Item.mineItems()
        tableNode.reloadData()
    }
    
}

extension MineViewController: ASTableDataSource, ASTableDelegate {
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
            
            let cell = ASTextCellNode()
            let realm = try! Realm()
            guard let item = realm.resolve(itemRef) else {
                return cell
            }
            cell.textNode.attributedText = InformationNode.getTitleString(string: item.title)
            return cell
        }
        
        return cellNodeBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let item = items![indexPath.row]
        let vc = ProductViewController(item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
