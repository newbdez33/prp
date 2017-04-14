//
//  InformationNode.swift
//  pr
//
//  Created by JackyZ on 2017/04/14.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class InformationNode: ASDisplayNode {
    
    static let nodeHeight:CGFloat = 150
    
    let imageNode = ASNetworkImageNode()
    let titleNode = ASTextNode()
    
    override init() {
        super.init()
        titleNode.truncationMode = .byTruncatingMiddle
        addSubnode(imageNode)
        addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize =  CGSize(width: 120, height: 120)
        let right = ASStackLayoutSpec(direction: .vertical, spacing: 2, justifyContent: .center, alignItems: .center, children:[titleNode])
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 2, justifyContent: .center, alignItems: .center, children: [imageNode, right])
        right.style.flexGrow = 1
        right.style.flexShrink = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), child: stack)
    }
    
    class func getTitleString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15)!])
    }
    
}

extension InformationNode {
    func bindItem(_ item:Item) {
        if item.title != nil {
            titleNode.attributedText = InformationNode.getTitleString(string: item.title!)
        }
        if item.photo != nil {
            if let url = URL(string:item.photo!) {
                imageNode.url = url
            }
        }
    }
}
