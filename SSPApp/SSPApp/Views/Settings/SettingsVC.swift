//
//  SettingsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 19/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class SettingsVC: ViewControllerWithDrawerMenu {
    //MARK - storybord management
    static func getViewController() -> SettingsVC {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        return controller as! SettingsVC
    }
    
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationVC")
        return controller as! UINavigationController
    }
    

}
