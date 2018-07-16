//
//  SdevInfo.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 16/05/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class SdevInfo {
    var symId: String = ""
    var sspId: String = ""
    var pluginId: String = ""
    var pluginURL: String = ""
    var dk1: String = ""
    var hashField: String = ""
    
    
    public func toJsonRequestBody() -> JSON {
        let json = JSON(
            ["symId":"iOS_sdev_test",
             "sspId":"unidata",
             "pluginId":"",
             "pluginURL":"",
             "dk1":"",
             "hashField":"0000"
            ]
        )
        
        logVerbose(json.rawString(options: []))
        return json
    }
    
    private func buidFakeDebugTestRequest() -> JSON {
        let json = JSON(
            ["symId":symId,
             "sspId":sspId,
             "pluginId":pluginId,
             "pluginURL":pluginURL,
             "dk1":dk1,
             "hashField":hashField
            ]
        )
        
        logVerbose(json.rawString(options: []))
        return json
    }
}
