//
//  ReportingBar.swift
//  GryoscopeTest
//
//  Created by Martin Roeder on 1/23/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import Foundation
import UIKit

class ReportingBar: UIView {
    
    var resultArray:[Bool] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        let count = resultArray.count
        
        UIColor.grayColor().setFill()
        path.fill()
        
        if count == 0 {
            return
        }
        
        // Drawing variables
        var x:CGFloat = 0
        let y:CGFloat = 0
        let w:CGFloat = frame.width / CGFloat(count)
        let h = frame.height
        
        // Loop through the elments in the array
        var index = 0
        while index < count {
            
            let currentResult = resultArray[index]
            
            // Determine the next color
            if resultArray[index] {
                UIColor.greenColor().setFill()
                UIColor.greenColor().setStroke()
            }
            else {
                UIColor.redColor().setFill()
                UIColor.redColor().setStroke()
            }
            
            // Determine the size of the next color
            var wNext:CGFloat = 0
            while (index < resultArray.count && resultArray[index] == currentResult) {
                wNext += w
                index++
            }
            let resultPath = UIBezierPath(rect:CGRect(x: x, y: y, width: wNext, height: h))
            
            // Draw rectangle
            resultPath.fill()
            resultPath.stroke()
            
            // Increment to next rectangle
            x += wNext
            
        }
        
    }
    
    func addResult(result: Bool) -> Void {
        resultArray.append(result)
        setNeedsDisplay()
    }
}