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
    
    var nextX:CGFloat = 0
    var nextY:CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.grayColor().setFill()
        path.fill()
        
        nextX = 0
        nextY = 0
        
        let w:CGFloat = 2
        let h = frame.height
        
        for result in resultArray {
            let resultPath = UIBezierPath(rect:CGRect(x: nextX, y: nextY, width: w, height: h))
            
            if result {
                UIColor.greenColor().setFill()
            }
            else {
                UIColor.redColor().setFill()
            }
            resultPath.fill()
            
            nextX += w
            
            // Delete the data and start drawing again - this needs to be updated if we want to save the data
            if nextX > frame.width {
                resultArray.removeAll(keepCapacity: true)
                return
            }
        }
        
    }
    
    func addResult(result: Bool) -> Void {
        resultArray.append(result)
        //print("There are \(resultArray.count) items in the resultArray")
        setNeedsDisplay()
    }
}