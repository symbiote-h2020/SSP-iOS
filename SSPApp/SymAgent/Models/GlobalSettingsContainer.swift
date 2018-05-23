//
//  GlobalSettingsContainer.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 19/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation

private struct Keys {
    static let restApiUrl: String = "restApiUrl"
    static let coreInterfaceApi: String = "coreInterfaceApi"
}

public final class GlobalSettingsContainer: NSObject, NSCoding {

    public var restApiUrl: String = "http://217.72.97.9:8080"
    public var coreInterfaceApi: String = "https://symbiote-open.man.poznan.pl/coreInterface/"
    
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.restApiUrl, forKey: Keys.restApiUrl)
        aCoder.encode(self.coreInterfaceApi, forKey: Keys.coreInterfaceApi)
    }
    
    @objc convenience public init?(coder aDecoder: NSCoder) {
        self.init()
        if aDecoder.containsValue(forKey: Keys.restApiUrl) {
            self.restApiUrl = aDecoder.decodeObject(forKey: Keys.restApiUrl) as! String
        }
        else {
            self.restApiUrl = "http://217.72.97.9:8080"
        }
        if aDecoder.containsValue(forKey: Keys.coreInterfaceApi) {
            self.coreInterfaceApi = aDecoder.decodeObject(forKey: Keys.coreInterfaceApi) as! String
        }
        else {
            self.coreInterfaceApi = "https://symbiote-open.man.poznan.pl/coreInterface/"
        }
        
    }

}
