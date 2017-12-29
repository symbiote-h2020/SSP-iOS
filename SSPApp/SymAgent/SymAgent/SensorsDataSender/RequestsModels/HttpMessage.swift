//
//  AbstractMessage.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 29/12/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class HttpMessage {
    var httpMethod = "POST"
    var request: URLRequest
    
    init(_ strUrl: String) {
        let url = URL(string: strUrl)!
        self.request = URLRequest(url: url)
        self.request.httpMethod = self.httpMethod
        
    }
    
    ///must be overriten
    func setJson() {
        preconditionFailure("setJson method must be overridden")
    }
    
}
