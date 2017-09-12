//
//  ActuatorVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 06/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class ActuatorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK - storybord management
    static func getViewController() -> ActuatorVC {
        let storyboard = UIStoryboard(name: "Actuators", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ActuatorVC")
        return controller as! ActuatorVC
    }
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Actuators", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ActuatorNavigationVC")
        return controller as! UINavigationController
    }

}
