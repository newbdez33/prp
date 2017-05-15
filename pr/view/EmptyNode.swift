//
//  EmptyNode.swift
//  pr
//
//  Created by JackyZ on 2017/05/15.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EmptyNode: ASDisplayNode {
    let titleLabel = ASTextNode()
    let imageNode:ASImageNode = {
        let img = ASImageNode()
        img.image = UIImage(named: "empty")
        return img
    }()
    let openButton = ASButtonNode()
    
    override init() {
        super.init()
        titleLabel.attributedText = NSAttributedString(string: "Oops, This list is empty.", attributes: [ NSForegroundColorAttributeName : UIColor.prGray(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 13)!])
        addSubnode(titleLabel)
        addSubnode(imageNode)
        
        openButton.setTitle("How to use it >", with: UIFont(name: "HelveticaNeue-Light", size: 13)!, with: UIColor(colorLiteralRed: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        addSubnode(openButton)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.height = ASDimensionMake(40)
        return ASStackLayoutSpec(direction: .vertical, spacing: 16, justifyContent: .center, alignItems: .center, children:[imageNode, titleLabel, openButton, spacer])
    }
    
}
