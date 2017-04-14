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
    let titleLabel = ASTextNode()
    
    override init() {
        super.init()
        addSubnode(titleLabel)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.height = ASDimensionMake(40)
        return ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .center, alignItems: .center, children:[spacer, titleLabel])
    }
    
    class func getTitleString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!])
    }
}

extension ProductNode {
    func bindItem(_ item:Item) {
        if item.title != nil {
            titleLabel.attributedText = ProductNode.getTitleString(string: item.title!)
        }
    }
}
