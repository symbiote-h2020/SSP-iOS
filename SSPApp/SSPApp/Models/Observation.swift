//
//  Observation.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Observation {
    
    var resourceId: String = ""
    var resultTime: String = ""  //TODO parse time to DateTime
    var samplingTime: String = ""
    
    var location: ObservationLocation?
    var values: [ObservationValue] = [ObservationValue]()
    
    
    convenience init(j: JSON)  {
        self.init()
        
        
        if j["resourceId"].exists()     { resourceId = j["resourceId"].stringValue }
        if j["resultTime"].exists()     { resultTime = j["resultTime"].stringValue }
        if j["samplingTime"].exists()     { samplingTime = j["samplingTime"].stringValue }
        
        if j["location"].exists()     {
            let jLoc = j["location"]
            self.location = ObservationLocation(j: jLoc)
        }
        
        if j["obsValues"] .exists()     {
            let jArrObsValues = j["obsValues"].arrayValue
            for childJson in jArrObsValues {
                let obsV = ObservationValue(j: childJson)
                values.append(obsV)
            }
        }
    }
}
