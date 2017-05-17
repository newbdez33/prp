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
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = true
        chartView.scaleXEnabled = true
        chartView.scaleYEnabled = false
        chartView.doubleTapToZoomEnabled = false
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
        chartView.xAxis.avoidFirstLastClippingEnabled = false
        
        let marker = PriceMarker(color:UIColor.clear, font:UIFont(name: "HelveticaNeue-Light", size: 8)!, textColor:UIColor.prBlack(), insets:UIEdgeInsetsMake(0, 0, 0, 0))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 20)
        chartView.marker = marker
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
        
        titleNode.attributedText = TrendingNode.getTitleString(string: NSLocalizedString("Trending", comment:""))
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
            let d = ChartDataEntry(x: Double(index), y: Double(p.price), data:p)
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
        set1.drawValuesEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        
        let chartView = lineChartNode.view as! LineChartView
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xvals)
        chartView.data = LineChartData(dataSets: [set1])

    }
    
}


class PriceMarker: MarkerImage
{
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()
    
    fileprivate var labelns: NSString?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [String : AnyObject]()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init()
        
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        if labelns == nil
        {
            return
        }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        if let color = color
        {
            context.setFillColor(color.cgColor)
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        labelns?.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {

        guard let p = entry.data as? Price else {
            setLabel("")
            return
        }
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd"
        let dt = Date(timeIntervalSince1970: TimeInterval(p.t))
        setLabel( p.currency + String(entry.y) + " " + dayTimePeriodFormatter.string(from: dt))
    }
    
    open func setLabel(_ label: String)
    {
        labelns = label as NSString
        
        _drawAttributes.removeAll()
        _drawAttributes[NSFontAttributeName] = self.font
        _drawAttributes[NSParagraphStyleAttributeName] = _paragraphStyle
        _drawAttributes[NSForegroundColorAttributeName] = self.textColor
        
        _labelSize = labelns?.size(attributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
