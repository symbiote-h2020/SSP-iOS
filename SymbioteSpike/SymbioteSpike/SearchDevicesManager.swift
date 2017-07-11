//
//  SearchDevicesManager.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 10/07/2017.
//  Copyright © 2017 Konrad Leszczyński. All rights reserved.
//

import Foundation


class SearchDevicesManager {
    

    static func getTestData() {

        let url = URL(string: "https://symbiote-dev.man.poznan.pl:8100/coreInterface/v1/query")

        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("", forHTTPHeaderField: "X-Auth-Token")  //TODO: proper secure token
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if error != nil {
                print(error)
            }
            else {
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                print(dataString)
            }
        }
        
        task.resume()
    }
    
    
    
    
    
}
