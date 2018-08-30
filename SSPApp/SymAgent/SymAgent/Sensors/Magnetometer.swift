//
//  Magnetometer.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 01/12/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SensingKit
import SymbioteIosUtils

class Magnetometer {
    //MARK: ------------   SensingKit
    //https://github.com/SensingKit/SensingKit-iOS/blob/master/README.md
    let sensingKit = SensingKitLib.shared()
    
    func readSensorsData() {
        do {
           
            if sensingKit.isSensorAvailable(SKSensorType.Magnetometer) {
                logVerbose("sensingKit.isSensorAvailable(SKSensorType.microfon)= \(sensingKit.isSensorAvailable(SKSensorType.Magnetometer))")
            }
            
            do {
               // try sensingKit.register(SKSensorType.Microphone)
               // try sensingKit.register(SKSensorType.Accelerometer)
                try sensingKit.register(SKSensorType.Magnetometer)
            }
            catch {
                logError("register  error: \(error)")
            }
            

            
            try sensingKit.subscribe(to: SKSensorType.Magnetometer, withHandler: { (sensorType, sensorData, error) in
                
                if (error == nil) {
                    let batteryData = sensorData as! SKMagnetometerData
                    log("SKMagnetometerData: \(batteryData)")
                }
                else {
                    logError("SKMagnetometerData error: \(error.debugDescription)")
                }
            })
          
        }
        catch {
            NSLog("cannot subscribe ")
        }
        
        
        
        
        // Start measurments
        do {
            try sensingKit.startContinuousSensing(with: SKSensorType.Magnetometer)
            //try sensingKit.startContinuousSensing(with: SKSensorType.Microphone)
            //a lot of data per second  try sensingKit.startContinuousSensing(with: SKSensorType.Accelerometer)
        }
        catch {
            // Handle error
            NSLog("Handle error - star sensing")
        }
    }
    
}
