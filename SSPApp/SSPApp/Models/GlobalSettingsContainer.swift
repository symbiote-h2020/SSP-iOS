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
}

public final class GlobalSettingsContainer: NSObject, NSCoding {

    public var restApiUrl: String = "http"
    
    
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.restApiUrl, forKey: Keys.restApiUrl)
    }
    
    @objc convenience public init?(coder aDecoder: NSCoder) {
        self.init()
        self.restApiUrl = aDecoder.decodeObject(forKey: Keys.restApiUrl) as! String
    }

}
