//
//  Magnetometer.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 01/12/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SensingKit

class Magnetometer {
    //MARK: ------------   SensingKit
    //https://github.com/SensingKit/SensingKit-iOS/blob/master/README.md
    let sensingKit = SensingKitLib.shared()
    
    func readSensorsData() {
        do {
            
            
            
            
            if sensingKit.isSensorAvailable(SKSensorType.Microphone) {
                print("sensingKit.isSensorAvailable(SKSensorType.microfon)= \(sensingKit.isSensorAvailable(SKSensorType.Microphone))")
            }
            
            if sensingKit.isSensorAvailable(SKSensorType.Magnetometer) {
                print("sensingKit.isSensorAvailable(SKSensorType.microfon)= \(sensingKit.isSensorAvailable(SKSensorType.Magnetometer))")
            }
            
            do {
                try sensingKit.register(SKSensorType.Microphone)
                try sensingKit.register(SKSensorType.Accelerometer)
                try sensingKit.register(SKSensorType.Magnetometer)
            }
            catch {
                print("register  error: \(error)")
            }
            
            try sensingKit.subscribe(to: SKSensorType.Microphone, withHandler: { (sensorType, sensorData, error) in
                
                if (error == nil) {
                    let batteryData = sensorData as! SKMicrophoneData
                    print("microphon Level: \(batteryData)")
                }
                else {
                    print("microphone error: \(error)")
                }
            })
            
            try sensingKit.subscribe(to: SKSensorType.Magnetometer, withHandler: { (sensorType, sensorData, error) in
                
                if (error == nil) {
                    let batteryData = sensorData as! SKMagnetometerData
                    print("SKMagnetometerData: \(batteryData)")
                }
                else {
                    print("SKMagnetometerData error: \(error)")
                }
            })
            
            
            
            try sensingKit.subscribe(to: SKSensorType.Accelerometer, withHandler: { (sensorType, sensorData, error) in
                
                if (error == nil) {
                    let batteryData = sensorData as! SKAccelerometerData
                    print("SKAccelerometer Level: \(batteryData)")
                }
                else {
                    print("SKAccelerometer error: \(error)")
                }
            })
            
            
        }
        catch {
            NSLog("cannot subscribe ")
        }
        
        
        
        
        // Start
        do {
            try sensingKit.startContinuousSensing(with: SKSensorType.Magnetometer)
            try sensingKit.startContinuousSensing(with: SKSensorType.Microphone)
            //a lot of data per second  try sensingKit.startContinuousSensing(with: SKSensorType.Accelerometer)
        }
        catch {
            // Handle error
            NSLog("Handle error - star sensing")
        }
    }
    
}
