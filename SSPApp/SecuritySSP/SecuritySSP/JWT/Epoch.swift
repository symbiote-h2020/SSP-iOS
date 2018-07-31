//
//  Epoch.swift
//  Demo-iOS
//
//  Created by Sebastian Mamczak on 30.07.2018.
//  Copyright © 2018 Agens AS. All rights reserved.
//

import Foundation

class Epoch {
    
    let date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    convenience init() {
        self.init(date: Date())
    }
    
    convenience init(after time: TimeInterval) {
        self.init(date: Date().addingTimeInterval(time))
    }
    
    func getString() -> String {
        return "\(date.timeIntervalSince1970)".components(separatedBy: ".")[0]
    }
}
