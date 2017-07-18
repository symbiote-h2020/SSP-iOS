//
//  Device.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 13/07/2017.
//  Copyright © 2017 Konrad Leszczyński. All rights reserved.
//

import Foundation
import SwiftyJSON


class Device {
    var platformId: String = ""
    var platformName: String = ""
    var owner: String =  ""
    var name: String = ""
    var id: String = ""
    var deviceDescription: String = ""
    
    //location
    
    convenience init(j: JSON)  {
        self.init()
        
        if j["platformId"].exists()     { platformId = j["platformId"].stringValue }
        if j["platformName"].exists()   { platformName = j["platformName"].stringValue }
        if j["owner"].exists()          { owner = j["owner"].stringValue }
        if j["name"].exists()           { name = j["name"].stringValue }
        if j["id"].exists()             { id = j["id"].stringValue }
        if j["description"].exists()    { deviceDescription = j["description"].stringValue }

    }
    
    
}
