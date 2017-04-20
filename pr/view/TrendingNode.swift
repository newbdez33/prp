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
        chartView.leftAxis.gridColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        
        chartView.xAxis.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1
        chartView.xAxis.xOffset = 5
        chartView.xAxis.avoidFirstLastClippingEnabled = true
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
        addSubnode(lineChartNode)
        updateChart(prices)
        
    }
    
    func updateChart(_ prices:[Price]) {
        if prices.count <= 0 {
            return
        }
        var vals:[ChartDataEntry] = []
        var xvals:[String] = []
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "M.d"
        for (index, p) in prices.enumerated() {
            let d = ChartDataEntry(x: Double(index), y: Double(p.price))
            let dt = Date(timeIntervalSince1970: TimeInterval(p.t))
            xvals.append(dayTimePeriodFormatter.string(from: dt))
            vals.append(d)
        }
        
        //last item
        let l = ChartDataEntry(x: Double(prices.count), y: Double(prices.last!.price))
        vals.append(l)
        xvals.append("")
        
        //TODO padding dates to 30 days
        
        let set1 = LineChartDataSet(values: vals, label: "set1")
        set1.setColor(UIColor.prBlack())
        set1.lineWidth = 1.0
        set1.drawCirclesEnabled = false
        set1.drawFilledEnabled = true
        set1.mode = .stepped
        
        let chartView = lineChartNode.view as! LineChartView
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xvals)
        chartView.data = LineChartData(dataSets: [set1])

    }
}
