//
//  CapabilitiesParameters.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 28/05/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class CapabilitiesParameters {
    var name: String = ""
    var mandatory: Bool = false
    var restricitons: [Restriction] = [Restriction]()
    
    public convenience init(_ cpj: JSON)  {
        self.init()
        
        if cpj["name"].exists() { name = cpj["name"].stringValue  }
        if cpj["mandatory"].exists() { mandatory = cpj["mandatory"].boolValue}
        if cpj["restrictions"].exists() {
            for r in cpj["restrictions"].arrayValue {
                restricitons.append(Restriction(r))
            }
        }
    }
}

public class Restriction {
    var cName: String = ""
    var min: Int = 0
    var max: Int = 1
    
    public convenience init(_ cpj: JSON)  {
        self.init()
        
        if cpj["@c"].exists() { cName = cpj["@c"].stringValue }
        if cpj["min"].exists() { min = cpj["min"].intValue }
        if cpj["max"].exists() { max = cpj["max"].intValue }
    }
}

public class DataType {
    //TODO if this information is needed - make a parser
}
