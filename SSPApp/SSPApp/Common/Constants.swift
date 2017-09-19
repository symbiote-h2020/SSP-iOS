//
//  Constants.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 14/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation


final class Constants {
    static let isDebug: Bool                                        = _isDebugAssertConfiguration()
    static let isVerboseLogging: Bool                               = true  //TODO: zrobić zaawansowaną konfigurację jak w loggerze microsoftowym
    
    static var restApiUrl: String  = "http://217.72.97.9:8080"
}
