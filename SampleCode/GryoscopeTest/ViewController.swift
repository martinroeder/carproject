//
//  ViewController.swift
//  GryoscopeTest
//
//  Created by Martin Roeder on 1/19/16.
//  Copyright © 2016 Martin Roeder. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var attitudeLabel:UILabel!
    @IBOutlet var stabilityResult: ReportingBar!
    @IBOutlet weak var stabilityLabel: UILabel!
    
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    var referenceAttitude:[CMAttitude] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                let attitude = motion!.attitude
                
                let attitudeText = String(format: "Roll: %+.2f, Pitch: %+.2f, Yaw: %+.2f",
                    attitude.roll, attitude.pitch, attitude.yaw)
                
                // Populate the reference array
                if self.referenceAttitude.isEmpty {
                    self.referenceAttitude = [CMAttitude](count:5, repeatedValue:attitude)
                }
                else {
                    self.referenceAttitude.removeLast()
                    self.referenceAttitude.insert(attitude, atIndex: 0)
                }
                
                // See if the device has been stable
                let stabilityScore = self.getDeviceStabilityScore(self.referenceAttitude)
                
                // Convert score to text
                var stabilityText:String
                var isStable:Bool = false
                switch stabilityScore {
                case 1:
                    stabilityText = "Not Stable"
                case 2:
                    stabilityText = "Better"
                case 3:
                    stabilityText = "Medium"
                case 4:
                    stabilityText = "Almost Stable"
                case 5:
                    stabilityText = "Stable"
                    isStable = true
                default:
                    stabilityText = "Unknown"
                }
                

                dispatch_async(dispatch_get_main_queue(), {
                    self.attitudeLabel.text = attitudeText
                    self.stabilityLabel.text = stabilityText
                    self.stabilityResult.addResult(isStable)
                    
                    
                })
            })
        }
    }
    
    func getDeviceStabilityScore(attitudeArray:[CMAttitude]) -> Int {
        
        var score = 0
        let marginOfError = 0.2;
        
        if let reference = attitudeArray.first {
            for a in attitudeArray {
                let pitchChanged = fabs(reference.pitch - a.pitch) > marginOfError
                let rollChanged = fabs(reference.roll - a.roll) > marginOfError
                let yawChanged = fabs(reference.yaw - a.yaw) > marginOfError
                
                if pitchChanged || rollChanged || yawChanged {
                    return score
                }
                score++
            }
        }
        
        return score
    }

}

