//
//  ObservationsChartVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 24/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class ObservationsChartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK - storybord management
    static func getViewController() -> ObservationsChartVC {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsChartVC")
        return controller as! ObservationsChartVC
    }
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsChartNavigationVC")
        return controller as! UINavigationController
    }

}
