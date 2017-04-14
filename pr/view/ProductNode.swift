//
//  ProductNode.swift
//  pr
//
//  Created by JackyZ on 2017/04/04.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ProductNode: ASDisplayNode {
    
    let infoNode = InformationNode()
    let priceNode = PriceNode()
    let trendingNode = TrendingNode()
    
    override init() {
        super.init()
        addSubnode(infoNode)
        addSubnode(priceNode)
        addSubnode(trendingNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        infoNode.style.height = ASDimensionMake(InformationNode.nodeHeight)
        priceNode.style.height = ASDimensionMake(PriceNode.nodeHeight)
        trendingNode.style.height = ASDimensionMake(TrendingNode.nodeHeight)
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .center, alignItems: .stretch, children:[infoNode, priceNode, trendingNode])
        
        return stack
    }
    
    func heightOfContents() -> CGFloat {
        return InformationNode.nodeHeight + PriceNode.nodeHeight + TrendingNode.nodeHeight
    }
    
}

extension ProductNode {
    func bindItem(_ item:Item) {
        infoNode.bindItem(item)
    }
}
