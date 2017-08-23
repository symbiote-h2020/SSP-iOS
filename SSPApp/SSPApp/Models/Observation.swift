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
    var resultTime: String = ""
    var samplingTime: String = ""
    
    
    convenience init(j: JSON)  {
        self.init()
        
        
        if j["resourceId"].exists()     { resourceId = j["resourceId"].stringValue }
        if j["resultTime"].exists()     { resultTime = j["resultTime"].stringValue }
        if j["samplingTime"].exists()     { samplingTime = j["samplingTime"].stringValue }
    }
}
