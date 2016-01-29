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
    
    var resultArray:[Double] = [20, 16, 17, 20, 25, 22, 18, 14, 7, 3, 10, 20, 30, 40, 50, 80, 82, 60]
    let speedLabels = [80, 60, 40, 20, 0]
    let font = UIFont.systemFontOfSize(14)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = UIViewContentMode.Redraw
    }
    
    override func drawRect(rect: CGRect) {
        
        // Draw Chart
        drawBackground(rect)
        drawLabels(CGRect(x:0, y:0, width: 40, height: rect.height))
        drawGridLines(CGRect(x:50, y:0, width: rect.width - 10, height: rect.height))
        
        // Draw Data
        drawData(CGRect(x: 50, y: 0, width: rect.width - 10, height: rect.height))
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
        var y:CGFloat = (rect.height / CGFloat(speedLabels.count) - font.pointSize) / 2
        
        for sl in speedLabels {
            let label = UILabel(frame: CGRect(x: x, y: y, width: rect.width, height: font.pointSize))
            label.textAlignment = NSTextAlignment.Right
            label.text = "\(sl)"
            self.addSubview(label)
            y += rect.height / CGFloat(speedLabels.count)
        }
        
    }
    
    func drawGridLines(rect:CGRect) {
        let gridWidth:CGFloat = rect.height / CGFloat(speedLabels.count)

        let x:CGFloat = rect.origin.x
        var y:CGFloat = gridWidth / 2
        
        let gridLines = UIBezierPath()
        
        for _ in speedLabels {
            gridLines.moveToPoint(CGPoint(x: x, y: y))
            gridLines.addLineToPoint(CGPoint(x: rect.width, y: y))
            y += gridWidth
        }

        UIColor.blackColor().setStroke()
        gridLines.lineWidth = 1.0
        gridLines.stroke()
        
    }
    
    func drawData(rect:CGRect) {
        
        if resultArray.count < 2 {
            return
        }

        let yScale:CGFloat = rect.height / CGFloat(speedLabels.count) / 20
        let yZero:CGFloat = rect.height - rect.height / CGFloat(speedLabels.count) / 2
        
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