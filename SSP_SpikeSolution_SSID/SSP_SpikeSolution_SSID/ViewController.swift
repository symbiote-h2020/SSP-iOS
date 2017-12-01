//
//  ViewController.swift
//  SSP_SpikeSolution_SSID
//
//  Created by Konrad Leszczyński on 02/11/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
//import NetworkExtension
import AVFoundation
import CoreAudio
import Foundation

import SensingKit

class ViewController: UIViewController {
    //MARK: - backgroundTask
    @IBOutlet var resultsLabel: UILabel!
    
    var previous = NSDecimalNumber.one
    var current = NSDecimalNumber.one
    var position: UInt = 1
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
//        startCounting()
        makeMenu()
        
        initDecibel()
    }
    
    func makeMenu() {
        let button1 = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(ViewController.menuBarButtonTapped))
        self.navigationItem.rightBarButtonItem  = button1
        

    }
    
    func menuBarButtonTapped(_ sender: AnyObject) {
        guard let button = sender as? UIBarButtonItem else {
            return
        }
        
        let menuAlertController = UIAlertController(title: "menu", message: "", preferredStyle: .actionSheet)
        menuAlertController.modalPresentationStyle = .popover
        
        
        let reloadAction = UIAlertAction(title: "b", style: .default) { action in

        }
        menuAlertController.addAction(reloadAction)
        
        let infoAction = UIAlertAction(title: "a", style: .default) { action in
            
        }
        menuAlertController.addAction(infoAction)
        
        
        
        if let presenter = menuAlertController.popoverPresentationController {
            presenter.barButtonItem = button
        }
        present(menuAlertController, animated: true, completion: nil)
    }
    
    deinit {
        stopCounting()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func reinstateBackgroundTask() {
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
    func startCounting() {
            resetCalculation()
            updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                               selector: #selector(calculateNextNumber), userInfo: nil, repeats: true)
            registerBackgroundTask()
    }
        
    func stopCounting(){
            updateTimer?.invalidate()
            updateTimer = nil
            if backgroundTask != UIBackgroundTaskInvalid {
                endBackgroundTask()
            }
    }
    
    func resetCalculation() {
        previous = NSDecimalNumber.one
        current = NSDecimalNumber.one
        position = 1
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    func calculateNextNumber() {
        let result = current.adding(previous)
        
        let bigNumber = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
        if result.compare(bigNumber) == .orderedAscending {
            previous = current
            current = result
            position += 1
        } else {
            // This is just too much.... Start over.
            resetCalculation()
        }
        
        let resultsMessage = "Position \(position) = \(current)"
        
        switch UIApplication.shared.applicationState {
        case .active:
            resultsLabel.text = resultsMessage
        case .background:
            print("App is backgrounded. Next number = \(resultsMessage)")
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        }
    }
    
    
    //MARK: WiFi
    func printCurrentWifiInfo() {
        if let interface = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interface) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interface, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                if let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString), let interfaceData = unsafeInterfaceData as? [String : AnyObject] {
                    // connected wifi
                    //print("BSSID: \(interfaceData["BSSID"]), SSID: \(interfaceData["SSID"]), SSIDDATA: \(interfaceData["SSIDDATA"])")
                    if let ssid = interfaceData["SSID"] {
                        print(ssid)
                    }
                } else {
                    // not connected wifi
                }
            }
        }
    }
    
    func getInterfaces() -> Bool {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            let cInterface = interface as CFString
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(cInterface) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
            }
        }
        return true
    }
    
    @IBAction func getWiFiTapped(_ sender: Any) {
        //printCurrentWifiInfo()
        getInterfaces()
        //getSSID()
        //getWithNetworkHelper()
        //connectToKonferencjaWiFi()
    }
    
    @IBAction func barButtonTapped(_ sender: Any) {
        makeMenu()
    }
    
    func getSSID() -> String? {
        
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            return nil
        }
        
        let interfacesArray = interfaces as! [String]
        if interfacesArray.count <= 0 {
            return nil
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData =     CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil {
            return nil
        }
        
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        
        return interfaceData["SSID"] as? String
    }
    
    /// może to - polaczenie po zmianie statusu http://jayeshkawli.ghost.io/ios-checking-the-network-status-swift/
/*
    func connectToKonferencjaWiFi() {
        let WiFiConfig = NEHotspotConfiguration(ssid: "konferencja",
                                                passphrase: "DF25sf@$T2",
                                                isWEP: false)
        
        WiFiConfig.joinOnce = false
        NEHotspotConfigurationManager.shared.apply(WiFiConfig) { error in
            // Handle error or success
            print(error?.localizedDescription)
        }
        
        

    }
    
    func getWithNetworkHelper(){
        let options: [String: NSObject] = [kNEHotspotHelperOptionDisplayName : "Join this WIFI" as NSObject]
        let queue: DispatchQueue = DispatchQueue(label: "com.mobiarch", attributes: DispatchQueue.Attributes.concurrent)
        
        NSLog("Started wifi scanning.")
        
        NEHotspotHelper.register(options: options, queue: queue) { (cmd: NEHotspotHelperCommand) in
            NSLog("Received command: \(cmd.commandType.rawValue)")
        }
        
        
        //        let cmd = NEHotspotHelperCommand()
//        let list = cmd.networkList
        
//        if let list = cmd.networkList where cmd.commandType == .FilterScanList {
//            var networks = [NEHotspotNetwork]()
//            for network in list {
//                if network.SSID.hasPrefix("BTVNET") {
//                    network.setPassword("12345678")
//                    network.setConfidence(.High)
//                    networks.append(network)
//                }
//            }
//            let response = cmd.createResponse(.Success)
//            response.setNetworkList(networks)
//            response.deliver()
//        }
    }
  */
    
    
    
    
    
    
    
    
    //MARK: ------------   SensingKit
    //https://github.com/SensingKit/SensingKit-iOS/blob/master/README.md
    let sensingKit = SensingKitLib.shared()
    
    @IBAction func readSensorDataTapped(_ sender: Any) {
        readSensorsData() 
    }
    
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
    
    
    
    //MARK: decibel meter
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    
    let LEVEL_THRESHOLD: Float = -10.0
    
    func initDecibel() {

        
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
        
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        let level = recorder.averagePower(forChannel: 0)
        let isLoud = level > LEVEL_THRESHOLD
        
        
        print("sound level = \(level) dB")
        // do whatever you want with isLoud
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    

}

