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
        titleLabel.attributedText = ProductNode.getTitleString(string: "test")
        addSubnode(titleLabel)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.height = ASDimensionMake(40)
        return ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .center, alignItems: .center, children:[spacer, titleLabel])
    }
    
    class func getTitleString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.blue, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!])
    }
}
