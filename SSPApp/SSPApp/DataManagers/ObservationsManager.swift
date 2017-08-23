//
//  ObservationsManager.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ObservationsManager {
    
    var currentObservations: [Observation] = [Observation]()
    
    
    func getTestData() {
        if let archiveUrl = Bundle.main.URLForResource("observations.json") {
            if let data = try? Data(contentsOf: archiveUrl) {
                log("loading test hardcoded data from observations.json")
                
                let json = JSON(data: data)
                parseOservationsJson(json)            }
        }
    }
    
    
    func parseOservationsJson(_ dataJson: JSON) {

        
        let jsonArr:[JSON] = dataJson.arrayValue
        for childJson in jsonArr {
            
            let dev = Observation(j: childJson)
            currentObservations.append(dev)
        }
        
        NotificationCenter.default.postNotificationName(SymNotificationName.ObservationsListLoaded)
    }
}


extension Bundle {
    
    func pathForResource(_ name: String?) -> String? {
        if let components = name?.components(separatedBy: ".") , components.count == 2 {
            return self.path(forResource: components[0], ofType: components[1])
        }
        return nil
    }
    
    func URLForResource(_ name: String?) -> URL? {
        if let components = name?.components(separatedBy: ".") , components.count == 2 {
            return self.url(forResource: components[0], withExtension: components[1])
        }
        return nil
    }
    
}

// MARK: infoDictionary
extension Bundle {
    
    var CFBundleName: String {
        return (infoDictionary?["CFBundleName"] as? String) ?? ""
    }
    
    var CFBundleShortVersionString: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
}
