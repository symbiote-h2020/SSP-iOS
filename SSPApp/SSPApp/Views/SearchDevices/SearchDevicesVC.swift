//
//  SearchDevicesVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 26/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class SearchDevicesVC: ViewControllerWithDrawerMenu {
    
    //MARK - storybord management
    static func getViewController() -> SearchDevicesVC {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchDevicesVC")
        return controller as! SearchDevicesVC
    }
    
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchDevicesNavigationVC")
        return controller as! UINavigationController
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //navigate
    @IBAction func searchButtonTapped(_ sender: Any) {
        let vc = DevicesListVC.getViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
