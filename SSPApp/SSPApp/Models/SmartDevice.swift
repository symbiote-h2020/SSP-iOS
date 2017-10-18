//
//  Device.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 13/07/2017.
//  Copyright © 2017 Konrad Leszczyński. All rights reserved.
//

import Foundation
import SwiftyJSON


public class SmartDevice {
    public var platformId: String = ""
    public var platformName: String = ""
    public var owner: String =  ""
    public var name: String = ""
    public var id: String = ""
    public var deviceDescription: String = ""
    public var status: String = ""
    
    //location
    public var locationName: String = ""
    public var locationLatitude: String = ""
    public var locationLongitude: String = ""
    public var locationAltitude: String = ""
    
    //array
    public var observedProperties: [String] = [String]()
    public var resourceType: [String] = [String]()
    
    public convenience init(j: JSON)  {
        self.init()
        
        if j["platformId"].exists()     { platformId = j["platformId"].stringValue }
        if j["platformName"].exists()   { platformName = j["platformName"].stringValue }
        if j["owner"].exists()          { owner = j["owner"].stringValue }
        if j["name"].exists()           { name = j["name"].stringValue
            //debug
//            if self.name == "A23" {
//                log("json=\(j)")
//            }
        }
        if j["id"].exists()             { id = j["id"].stringValue }
        if j["description"].exists()    { deviceDescription = j["description"].stringValue }
        if j["status"].exists()         { status = j["status"].stringValue }
        
        //location
        if j["locationName"].exists()           { locationName = j["locationName"].stringValue }
        if j["locationLatitude"].exists()       { locationLatitude = j["locationLatitude"].stringValue }
        if j["locationLongitude"].exists()      { locationLongitude = j["locationLongitude"].stringValue }
        if j["locationAltitude"].exists()       { locationAltitude = j["locationAltitude"].stringValue }

        if j["observedProperties"].exists() {
            for oP in j["observedProperties"].arrayValue {
                observedProperties.append(oP.stringValue)
            }
        } else if j["observesProperty"].exists() {              //I'm not sure about the naming convention so I'll parse both
            for oP in j["observesProperty"].arrayValue {
                observedProperties.append(oP.stringValue)
            }
        }
        
        
        if j["resourceType"].exists() {
            for r in j["resourceType"].arrayValue {
                resourceType.append(r.stringValue)
            }
        }

        

    }
    
    
    public static func makeDebugTestDevice() -> SmartDevice {
        let dev = SmartDevice()
        dev.id="aa"
        dev.name="Error"
        dev.locationName="Not found"
        dev.platformName="No devices"
        dev.deviceDescription="Debug test device in case of error"
        dev.status = "TEST"
        dev.observedProperties.append("debug data")
        return dev
    }
    
}
