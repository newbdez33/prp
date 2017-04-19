//
//  TrendingNode.swift
//  pr
//
//  Created by JackyZ on 2017/04/14.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts

class TrendingNode: ASDisplayNode {
    static let nodeHeight:CGFloat = 150
    let titleNode = ASTextNode()
    let lineChartNode = ASDisplayNode { () -> UIView in
        let chartView = LineChartView()
        chartView.noDataText = ""
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1
        chartView.leftAxis.xOffset = 0
        return chartView
    }
    
    override init() {
        super.init()
        //
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        lineChartNode.style.flexGrow = 1
        lineChartNode.style.flexShrink = 1
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .center, alignItems: .start, children:[titleNode, lineChartNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 12, bottom: 0, right: 12), child: stack)
    }
    
    class func getTitleString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15)!])
    }
}

extension TrendingNode {
    func bind(_ prices:[Price]) {

        if prices.count <= 0 {
            return
        }
        
        titleNode.attributedText = TrendingNode.getTitleString(string: "Trending")
        addSubnode(titleNode)
        
        var vals:[ChartDataEntry] = []
        for p in prices {
            let d = ChartDataEntry(x: Double(p.t), y: Double(p.price))
            vals.append(d)
        }
        let set1 = LineChartDataSet(values: vals, label: "set1")
        set1.setColor(UIColor.prBlack())
        set1.lineWidth = 1.0
        set1.drawCirclesEnabled = false
        set1.drawFilledEnabled = true
        set1.mode = .stepped
        let chartView = lineChartNode.view as! LineChartView
        chartView.data = LineChartData(dataSets: [set1])
        addSubnode(lineChartNode)
        
    }
}
