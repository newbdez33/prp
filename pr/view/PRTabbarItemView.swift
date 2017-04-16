//
//  PRTabbarItemView.swift
//  pr
//
//  Created by JackyZ on 2017/04/16.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class PRTabbarItemView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.prGray()
        iconColor = UIColor.prGray()
        highlightTextColor = UIColor.prBlack()
        highlightIconColor = UIColor.prBlack()
        backdropColor = UIColor.white
        highlightBackdropColor = UIColor.white
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
