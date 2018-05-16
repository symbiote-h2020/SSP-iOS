//
//  ObservationsManager.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ObservationsManager {
    public init() {}
    
    public var currentObservations: [Observation] = [Observation]()
    public var observationsByLocation: [String: [Observation]] = [String: [Observation]]()
    
    public func getTestData() {
        if let archiveUrl = Bundle.main.URLForResource("observationsFromSSP.json") {
            if let data = try? Data(contentsOf: archiveUrl) {
                logWarn("loading test hardcoded data from test file")
                
                do {
                    let json = try JSON(data: data)
                    parseOservationsJson(json)
                } catch {
                    logError("getTestData json")
                }
            }
        }
    }
    
    public func getObservations(forDeviceId: String!) {
        let url = URL(string: Constants.restApiUrl + "/rap/Sensor('" + forDeviceId + "')/Observations?$top=1")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(DateTime.Now., forHTTPHeaderField: "x-auth-timestamp")
        request.setValue("1", forHTTPHeaderField: "x-auth-size")
        request.setValue(TokensManager.shared.guestToken, forHTTPHeaderField: "X-Auth-Token")  //TODO: proper secure token
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.ObservationsListLoaded, object: notiInfoObj)
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    self.getTestData()
                    logError("response status: \(status)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.ObservationsListLoaded, object: notiInfoObj)
                }
                //debug
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                logVerbose(dataString)
                
                
                if let jsonData = data {
                    do {
                        let json = try JSON(data: jsonData)
                        self.parseOservationsJson(json)
                    } catch {
                        logError("getObservations json")
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    
    public func parseOservationsJson(_ dataJson: JSON) {
        let jsonArr:[JSON] = dataJson.arrayValue
        for childJson in jsonArr {
            
            let obs = Observation(j: childJson)
            currentObservations.append(obs)
            
            let location = obs.location?.name ?? "unknown location"
            if (observationsByLocation[location] == nil) {
                observationsByLocation[location] = [Observation]()
            }
            self.observationsByLocation[location]?.append(obs)
        }
        
        NotificationCenter.default.postNotificationName(SymNotificationName.ObservationsListLoaded)
    }
}

/// helpers use for reading test data from file
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
