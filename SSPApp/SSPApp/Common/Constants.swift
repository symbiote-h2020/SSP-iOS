//
//  Constants.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 14/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation


public final class Constants {
    public static let isDebug: Bool                                        = _isDebugAssertConfiguration()
    public static let isVerboseLogging: Bool                               = true  //TODO: zrobić zaawansowaną konfigurację jak w loggerze microsoftowym
    
    public static var restApiUrl: String  = "http://217.72.97.9:8080"
}
