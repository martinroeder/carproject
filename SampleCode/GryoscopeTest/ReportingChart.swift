//
//  ReportingChart.swift
//  GryoscopeTest
//
//  Created by Martin Roeder on 1/28/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import Foundation
import UIKit

class ReportingChart: UIView {
    
    // Random data generation for testing
    let resultArray:[Double] = (1..<100).map({ _ in Double(arc4random_uniform(15))})

    let font = UIFont.systemFontOfSize(14)
    
    var yAxisLabels:[Int] = []
    let gridLineCountInt:Int = 5
    let gridLinesCountFloat:CGFloat = 5.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = UIViewContentMode.Redraw
    }
    
    override func drawRect(rect: CGRect) {
        
        // Calculate labels
        calculateYLabels()
        
        // Draw Chart
        drawBackground(rect)
        drawLabels(CGRect(x:0, y:0, width: 40, height: rect.height))
        drawGridLines(CGRect(x:50, y:0, width: rect.width - 10, height: rect.height))
        
        // Draw Data
        drawData(CGRect(x: 50, y: 0, width: rect.width - 10, height: rect.height))
    }
    
    func calculateYLabels() {
        
        yAxisLabels.removeAll(keepCapacity: true)
        
        if let max = resultArray.maxElement() {

            let maxLabel = ceil(max / 20) * 20
            let scale = Int(maxLabel) / 4
    
            for index in 0..<gridLineCountInt {
                yAxisLabels.insert(scale * index, atIndex: 0)
            }
            print("yAxisLabels: \(yAxisLabels)")
        }
    }
    
    func drawBackground(rect:CGRect) {
        let background = UIBezierPath(rect: rect)
        UIColor.lightGrayColor().setFill()
        UIColor.lightGrayColor().setStroke()
        background.fill()
        background.stroke()
    }
    
    func drawLabels(rect:CGRect) {
        
        let x:CGFloat = 0
        var y:CGFloat = (rect.height / gridLinesCountFloat - font.pointSize) / 2
        
        for item in yAxisLabels {
            let label = UILabel(frame: CGRect(x: x, y: y, width: rect.width, height: font.pointSize))
            label.textAlignment = NSTextAlignment.Right
            label.text = "\(item)"
            self.addSubview(label)
            y += rect.height / gridLinesCountFloat
        }
        
    }
    
    func drawGridLines(rect:CGRect) {
        let gridWidth:CGFloat = rect.height / gridLinesCountFloat

        let x:CGFloat = rect.origin.x
        var y:CGFloat = gridWidth / 2
        
        let gridLines = UIBezierPath()
        
        for _ in yAxisLabels {
            gridLines.moveToPoint(CGPoint(x: x, y: y))
            gridLines.addLineToPoint(CGPoint(x: rect.width, y: y))
            y += gridWidth
        }

        UIColor.blackColor().setStroke()
        gridLines.lineWidth = 1.0
        gridLines.stroke()
        
    }
    
    func drawData(rect:CGRect) {
        
        if resultArray.count < 2   {
            return
        }

        let yScale:CGFloat = rect.height / gridLinesCountFloat / CGFloat(yAxisLabels[3])
        let yZero:CGFloat = rect.height - rect.height / gridLinesCountFloat / 2
        
        let xWidth:CGFloat = (rect.width - rect.origin.x) / (CGFloat(resultArray.count) - 1)
        var x:CGFloat = rect.origin.x

        // Create data path
        let dataLine = UIBezierPath()
        dataLine.moveToPoint(CGPoint(x: x, y: yZero - CGFloat(resultArray.first!) * yScale))
        for point in resultArray[1..<resultArray.count] {
            x += xWidth
            dataLine.addLineToPoint(CGPoint(x: x, y: yZero - CGFloat(point) * yScale))
        }
        
        // Stroke data path
        UIColor.blackColor().setStroke()
        dataLine.lineWidth = 2.0
        dataLine.stroke()
        
    }
    
    
    
}