//
//  AbstractInnkeeperConntector.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 15/12/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation


//methods to implement  https://colab.intracom-telecom.com/display/SYM/Interface:+messages+sent+to+SSP

class AbstractInnkeeperConntector {
    
    
    func sendRequest(message: HttpMessage) {

        let request = message.request

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                logError("error=\(error.debugDescription)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                logError("statusCode should be 200, but is \(httpStatus.statusCode)")
                log("response = \(response?.description ?? "no response")")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            log("responseString = \(responseString ?? "no response")")
        }
        task.resume()
    }
    
}
