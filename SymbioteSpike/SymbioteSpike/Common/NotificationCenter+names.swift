//
//  NotificationCenter+names.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 14/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import Async

//use as name for NSNotificationCenter.defaultCenter().postNotificationName
enum SymNotificationName: String {
    case DeviceListLoaded
}

extension AsyncBlock {
    
    /// executes immediately when in main thread or calls dispatch_async
    static func mainNowOrAsync(after: Double? = nil, block: @escaping ()->()) {
        if Thread.isMainThread {
            block()
        }
        else {
            Async.main(after: after, block)
        }
    }
    
}


extension NotificationCenter {
    
    func postNotificationName(_ aName: SymNotificationName, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        
        logVerbose("[NSNotificationCenter] Sending notification: \(aName.rawValue), object: \(String(describing: object)), userInfo: \(String(describing: userInfo))")
        
        

        
        
        // always in main thread
        Async.mainNowOrAsync {
            if object == nil {
                let notInfoObj  = NotificationInfo(type: ErrorType.noErrorSuccessfulFinish, info: "By default it works")
                self.post(name: Notification.Name(aName.rawValue), object: notInfoObj, userInfo: userInfo)
            }
            else {
                self.post(name: Notification.Name(aName.rawValue), object: object, userInfo: userInfo)
            }
        }
    }
    
    func addObserver(_ observer: AnyObject, selector: Selector, name: SymNotificationName, object: Any? = nil) {
        addObserver(observer, selector: selector, name: Notification.Name(name.rawValue), object: object)
    }
    
    func removeObserver(_ observer: AnyObject, name: SymNotificationName, object: AnyObject? = nil) {
        removeObserver(observer, name: Notification.Name(name.rawValue), object: object)
    }
    
}


extension Notification {
    
    init(name: SymNotificationName, object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
        self.init(name: Notification.Name(name.rawValue), object: object, userInfo: userInfo)
    }
    
}

