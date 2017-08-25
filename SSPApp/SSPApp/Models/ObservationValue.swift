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
    
    var unitLabel: String = ""
    var unitSymbol: String = ""
    var propertyLabel: String = ""

    
    convenience init(j: JSON)  {
        self.init()
        
        if j["value"].exists()     {
            valueString = j["value"].stringValue
            if let dVal = Double(valueString) {
                self.valueDouble = dVal
            }
        }
        
        if j["uom"].exists() {
            if j["uom"]["symbol"].exists() {
                unitSymbol = j["uom"]["symbol"].stringValue
            }
            if j["uom"]["label"].exists() {
                unitLabel = j["uom"]["label"].stringValue
            }
        }
        
        if j["obsProperty"]["label"].exists() {
            propertyLabel = j["obsProperty"]["label"].stringValue
        }       
    }
}
