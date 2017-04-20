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
    
    static let nodeHeight:CGFloat = 80
    
    let imageNode = ASNetworkImageNode()
    let titleNode = ASTextNode()
    
    override init() {
        super.init()
        titleNode.truncationMode = .byTruncatingMiddle
        imageNode.contentMode = .scaleAspectFit
        addSubnode(imageNode)
        addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize =  CGSize(width: InformationNode.nodeHeight * 0.9, height: InformationNode.nodeHeight * 0.9)
        let right = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .center, alignItems: .center, children:[titleNode])
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .center, alignItems: .center, children: [imageNode, right])
        right.style.flexGrow = 1
        right.style.flexShrink = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), child: stack)
    }
    
    class func getTitleString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 14)!])
    }
    
}

extension InformationNode {
    func bindItem(_ item:Item) {
        titleNode.attributedText = InformationNode.getTitleString(string: item.title)
        if item.photo != "" {
            if let url = URL(string:item.photo) {
                imageNode.url = url
            }
        }
    }
}
