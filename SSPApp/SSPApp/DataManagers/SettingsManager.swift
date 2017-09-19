//
//  SettingsManager.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 19/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation

class SettingsManager {
    var allSettings: GlobalSettingsContainer = GlobalSettingsContainer()
    
    var archiveUrl: String {
        //1 - manager lets you examine contents of a files and folders in your app; creates a directory to where we are saving it
        let manager = FileManager.default
        //2 - this returns an array of urls from our documentDirectory and we take the first path
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        //print("this is the url path in the documentDirectory \(url)")
        //3 - creates a new path component and creates a new file called "Data" which is where we will store our Data array.
        return (url!.appendingPathComponent("Data").path)
    }
    
    func loadSettings() {
        log("[GlobalSettingsManager] Reading file\n +++\(archiveUrl)")
        let isFileExist = FileManager.default.fileExists(atPath: archiveUrl)
        if (isFileExist) {
            log("[GlobalSettingsManager] Found settings file")
            allSettings = NSKeyedUnarchiver.unarchiveObject(withFile: archiveUrl) as! GlobalSettingsContainer
            
            
            Constants.restApiUrl = allSettings.restApiUrl
            
        }
        else {
            logWarn("[GlobalSettingsManager] Settings file not found. Will create new one")
            allSettings = GlobalSettingsContainer()
            
            let notiInfoObj  = NotificationInfo(type: ErrorType.wrongResult, info: "Cennot read settings")
            NotificationCenter.default.postNotificationName(SymNotificationName.Settings, object: notiInfoObj)
        }
    }
    
    func saveSettings() {
        log("[GlobalSettingsManager] Saving file\n +++\(archiveUrl)")
        let success = NSKeyedArchiver.archiveRootObject(allSettings, toFile: archiveUrl)
        if success {
            log("[GlobalSettingsManager] Saved settings")
            let notiInfoObj  = NotificationInfo(type: ErrorType.noErrorSuccessfulFinish, info: "OK - settings set")
            NotificationCenter.default.postNotificationName(SymNotificationName.Settings, object: notiInfoObj)
        }
        else {
            logError("[GlobalSettingsManager] Failed to save global settings")
        
            let notiInfoObj  = NotificationInfo(type: ErrorType.unspecyfied, info: "Cannot save settings")
            NotificationCenter.default.postNotificationName(SymNotificationName.Settings, object: notiInfoObj)
        }
        
        
    }
    
}
