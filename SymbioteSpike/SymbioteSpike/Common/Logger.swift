//
//  Logger.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 14/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation


func logVerbose(_ text: String?) {
    if Constants.isDebug && Constants.isVerboseLogging {
        logText("_L v_ ", text: text)
    }
}

func log(_ text: String?) {
    if Constants.isDebug {
        logText("_LOG_ ", text: text)
    }
}

func logTime(_ text: String?) {
    if let t = text {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "Y-MM-dd H:m:ss.SSSS"
        df.string(from: d)
        
        log("[\(df.string(from: d))]   \(t)")
    }
}

func logWarn(_ text: String?) {
    if Constants.isDebug {
        logText("__WARN __ ", text: text)
    }
}

func logError(_ text: String?) {
    logText("==  __ERROR__ == ", text: text)
}

private func logText(_ prefix: String, text: String?) {
    print(prefix + (text ?? ""))
}
