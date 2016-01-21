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
    
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.gryoscopeLabel.text = gryoscopeText
                    self.gravityLabel.text = gravityText
                    self.accelerometerLabel.text = accelerationText
                    self.attitudeLabel.text = attitudeText
                })
            })
        }
    }

}

