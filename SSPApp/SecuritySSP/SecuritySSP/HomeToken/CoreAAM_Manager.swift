//
//  CoreAAM_Manager.swift
//  SecuritySSP
//

import Foundation
import SwiftyJSON
//import EllipticCurve // at the end we have used EllipticCurveKeyPair lib

class CoreAAM_Manager {
    
    public var aams: [Aam] = [Aam]()
    
    let baseCoreUrl: String
    
    public static let shared = CoreAAM_Manager(GlobalSettings.coreInterfaceApiUrl)
    
    // Initialization
    private init(_ coreUrl: String) {
        self.baseCoreUrl = coreUrl
    }
    
    public func debugTest() {

        
    }
    
    
    public func getAvailableAams() {
        let url = URL(string: baseCoreUrl + "/get_available_aams")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation, object: notiInfoObj)
            }
            else {
                if let httpResponse = response as? HTTPURLResponse
                {
                    let status = httpResponse.statusCode
                    if (status >= 400) {
                        logWarn("response status: \(status)")
                    }
                    //debug
                    //let dataString = String(data: data!, encoding: String.Encoding.utf8)
                    //logVerbose("datastring= \(dataString ?? "    ")")
                    if let jsonData = data {
                        do {
                            let json = try JSON(data: jsonData)
                            self.parseAamsJson(json)
                            NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation)
                        } catch {
                            logError("getAvailableAams json")
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    private func parseAamsJson(_ dataJson: JSON) {
        if dataJson["availableAAMs"].exists() == false {
            logWarn("+++++++ wrong json +++++  parseAamsJson dataJson = \(dataJson)")
        }
        else {
            let jsonArr:JSON = dataJson["availableAAMs"]
            for (key, subJson) in jsonArr {
                logVerbose("AAM name = \(key)")
                let dev = Aam(subJson)
                aams.append(dev)
            }
        }
    }
}
