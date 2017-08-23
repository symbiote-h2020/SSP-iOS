//
//  ObservationLocation.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ObservationLocation {
    var name: String = ""
    var description: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var altitude: Double = 0.0
    
    convenience init(j: JSON)  {
        self.init()
     
        if j["name"].exists()     { name = j["name"].stringValue }
        if j["description"].exists()     { description = j["description"].stringValue }
        
        if j["latitude"].exists()     { latitude = j["latitude"].doubleValue }
        if j["longitude"].exists()     { longitude = j["longitude"].doubleValue }
        if j["altitude"].exists()     { altitude = j["altitude"].doubleValue }
    }
}
