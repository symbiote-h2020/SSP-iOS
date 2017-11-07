//
//  ViewController.swift
//  SSP_SpikeSolution_SSID
//
//  Created by Konrad Leszczyński on 02/11/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

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
        
        startCounting()
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
}

