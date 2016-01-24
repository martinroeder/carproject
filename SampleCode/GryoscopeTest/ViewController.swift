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
    
    @IBOutlet var gryoscopeLabel:UILabel!
    @IBOutlet var gravityLabel:UILabel!
    @IBOutlet var accelerometerLabel:UILabel!
    @IBOutlet var attitudeLabel:UILabel!
    @IBOutlet var stabilityResult: ReportingBar!
    
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    var referenceAttitude:[CMAttitude] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                let rotationRate = motion!.rotationRate
                let gravity = motion!.gravity
                let userAcc = motion!.userAcceleration
                let attitude = motion!.attitude
                
                let gryoscopeText = String(format:"Rotation Rate\n-------------\n x: %+.2f\n y: %+.2f\n z: %+.2f\n",
                    rotationRate.x, rotationRate.y, rotationRate.z)
                
                let gravityText = String(format: "Gravity\n-------\n x: %+.2f\n y: %+.2f\n z: %+.2f\n",
                    gravity.x, gravity.y, gravity.z)
                
                let accelerationText = String(format: "Acceleration\n------------\n x: %+.2f\n y: %+.2f\n z: %+.2f\n",
                    userAcc.x, userAcc.y, userAcc.z)
                
                let attitudeText = String(format: "Attitude\n--------\n Roll: %+.2f\n Pitch: %+.2f\n Yaw: %+.2f\n",
                    attitude.roll, attitude.pitch, attitude.yaw)
                
                if self.referenceAttitude.isEmpty {
                    self.referenceAttitude = [CMAttitude](count:5, repeatedValue:attitude)
                }
                else {
                    self.referenceAttitude.removeLast()
                    self.referenceAttitude.insert(attitude, atIndex: 0)
                }
                
                let stabilityScore = self.getDeviceStabilityScore(self.referenceAttitude)
                
                let attitudeChangeText = String(format: "Attitude Change\n--------\n Roll: %+.2f\n Pitch: %+.2f\n Yaw: %+.2f\n",
                    attitude.roll, attitude.pitch, attitude.yaw)
                
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
                    self.gryoscopeLabel.text = gryoscopeText
                    self.gravityLabel.text = gravityText
                    self.accelerometerLabel.text = attitudeChangeText + stabilityText
                    self.attitudeLabel.text = attitudeText
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

