//
//  ObservationValue.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ObservationValue {
    var valueString: String = ""
    var valueDouble: Double = 0.0
    

    
    convenience init(j: JSON)  {
        self.init()
        
        if j["value"].exists()     {
            valueString = j["value"].stringValue
            if let dVal = Double(valueString) {
                self.valueDouble = dVal
            }
        }
        
        //TODO units and properties
    }
}
