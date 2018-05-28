//
//  Capabilities.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 28/05/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON


public class Capabilities {

    var name: String = ""
    
    public convenience init(_ cJson: JSON)  {
        self.init()
        
        if cJson["name"].exists() { name = cJson["name"].stringValue  }
        
        if cJson["parameters"].exists() {
            for cP in cJson["parameters"].arrayValue {
                
            }
        }
    }
    
    
    
}


