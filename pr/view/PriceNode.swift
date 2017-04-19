//
//  PriceNode.swift
//  pr
//
//  Created by JackyZ on 2017/04/14.
//  Copyright © 2017 Salmonapps. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Charts

class PriceNode: ASDisplayNode {
    static let nodeHeight:CGFloat = 70
    
    let precentBarChartNode = ASDisplayNode { () -> UIView in
        let chartView = HorizontalBarChartView()
        //chartView.backgroundColor = UIColor.red
        chartView.noDataText = ""
        chartView.chartDescription?.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        chartView.minOffset = 0
        chartView.extraLeftOffset = -4
        chartView.drawBordersEnabled = false
        chartView.drawBarShadowEnabled = false
        
        chartView.xAxis.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 12)!
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1
        chartView.leftAxis.xOffset = 0
        
        chartView.leftAxis.enabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMinimum = 0.0
        
        chartView.fitBars = true
        chartView.legend.enabled = false
        chartView.isUserInteractionEnabled = false
        
        return chartView
    }
    
    let saveButton = ASButtonNode()
    
    
    override init() {
        super.init()
        saveButton.setImage(UIImage(named:"hearts"), for: [])
        saveButton.setImage(UIImage(named:"hearts-filled"), for: .selected)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        saveButton.style.preferredSize = CGSize(width: PriceNode.nodeHeight, height: PriceNode.nodeHeight)
        let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .start, alignItems: .center, children: [precentBarChartNode, saveButton])
        precentBarChartNode.style.flexGrow = 1
        precentBarChartNode.style.flexShrink = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), child: stack)
    }
    
    class func getPriceString(string:String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [ NSForegroundColorAttributeName : UIColor.prBlack(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 12)!])
    }
}

extension PriceNode {
    func bindItem(_ item:Item) {
        
        saveButton.isSelected = item.isTracking
        
        if item.price != 0 {
            //currentNode.attributedText = PriceNode.getPriceString(string: "\(item.price!)")
            let current = item.price
            var lowest = current
            var highest = current
            var currency = ""
            if item.lowest != 0 {
                lowest = item.lowest
            }
            if item.highest != 0 {
                highest = item.highest
            }
            if item.currency != "" {
                currency =  item.currency
            }
            let chartView = precentBarChartNode.view as! HorizontalBarChartView
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Lowest: \(currency)\(lowest)", "Highest: \(currency)\(highest)", "Current: \(currency)\(current)"])
            
            
            let yvals = [BarChartDataEntry(x: 0, y: Double(lowest)), BarChartDataEntry(x: 1, y: Double(highest)), BarChartDataEntry(x: 2, y: Double(current))]
            let set1 = BarChartDataSet(values: yvals, label: "prices")
            set1.colors = [UIColor.darkGray, UIColor.darkGray, UIColor.black]
            let data = BarChartData(dataSets: [set1])
            data.barWidth = 0.1
            data.setDrawValues(false)
            data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10))
            chartView.data = data
            
            addSubnode(precentBarChartNode)
            addSubnode(saveButton)
            
        }
    }
}
