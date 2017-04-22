//
//  ItemCellNode.swift
//  pr
//
//  Created by JackyZ on 2017/04/22.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ItemCellNode: ASCellNode {
    static let nodeHeight:CGFloat = 50
    
    let imageNode = ASNetworkImageNode()
    let titleNode = ASTextNode()
    let priceNode = ASTextNode()
    let infoButton = ASButtonNode()
    
    override init() {
        super.init()
        titleNode.truncationMode = .byTruncatingTail
        titleNode.maximumNumberOfLines = 2
        imageNode.contentMode = .scaleAspectFit
        infoButton.setImage(UIImage(named:"share"), for: .normal)
        addSubnode(imageNode)
        addSubnode(titleNode)
        addSubnode(infoButton)
        addSubnode(priceNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.style.preferredSize = CGSize(width: constrainedSize.max.width, height: ItemCellNode.nodeHeight)
        infoButton.style.preferredSize = CGSize(width: 50, height: 50)
        imageNode.style.preferredSize =  CGSize(width: InformationNode.nodeHeight * 0.9, height: InformationNode.nodeHeight * 0.9)
        let right = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .center, alignItems: .start, children:[titleNode, priceNode])
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .center, alignItems: .center, children: [imageNode, right, infoButton])
        right.style.flexGrow = 1
        right.style.flexShrink = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), child: stack)
    }
    
    func bind(item:Item) {
        titleNode.attributedText = ItemCellNode.getTitleString(string: item.title)
        if item.photo != "" {
            if let url = URL(string:item.photo) {
                imageNode.url = url
            }
        }
        
        priceNode.attributedText = ItemCellNode.getPriceString(previous: item.findLastChangedPrice(), current: item.price, currency: item.currency.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    class func getTitleString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 14)!])
    }
    
    class func getPriceString(previous:Float, current:Float, currency:String) -> NSAttributedString {
        if previous == current {
            return NSAttributedString(string: "\(currency)\(current)", attributes: [ NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 12)!])
        }else {
            let attrString = NSMutableAttributedString(string: "\(currency)\(previous)→",
                                                       attributes: [ NSForegroundColorAttributeName : UIColor.prGray(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 12)! ])
            
            attrString.append(NSMutableAttributedString(string: "\(currency)\(current)",
                                                        attributes: [NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 12)! ]))
            return attrString
        }
        

    }
}
