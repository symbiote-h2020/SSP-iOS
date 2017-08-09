//
//  SSPColors.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 09/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class SSPColors {
    
    // MARK: properties
    fileprivate static let defaultColor     = UIColor.black

    fileprivate static let background                  = UIColor.white
    fileprivate static let backgroundDifferentiate     = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) //gray to make every second element looks different
    fileprivate static let accentColor                 = UIColor(red: 119/255, green: 158/255, blue: 1.0, alpha: 1.0)
    fileprivate static let lightAccentColor            = UIColor(red: 196/255, green: 213/255, blue: 1.0, alpha: 1.0)
    fileprivate static let transparentAccentColor      = UIColor(red: 119/255, green: 158/255, blue: 1.0, alpha: 0.5)
    fileprivate static let onAccentColor               = UIColor.white //must look good on accent color
    fileprivate static let foregroundTextColor         = UIColor.black
    fileprivate static let subtleTextColor             = UIColor.gray
}
