//
//  DevicesCombinedVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 04/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import SymAgent
import SymbioteIosUtils

class DevicesCombinedVC: ViewControllerWithDrawerMenu, DevicesListViewControllerDelegate {

    var detailsEmbeddedViewController: DeviceDetailsVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Devices List and details"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DevicesListVCEmbededSegue" {
            if let childViewController = segue.destination as? DevicesListVC {
                childViewController.devicesListDelegate = self
            }
        }
        else if (segue.identifier == "DeviceDetailsEmbedSegue" ){
            if let vc = segue.destination as? DeviceDetailsVC {
                self.detailsEmbeddedViewController = vc
            }
        }
    }
    
    func childViewControllerDidPressButton(_ childViewController: DevicesListVC) {
        logVerbose("childViewControllerDidPressButton")
        detailsEmbeddedViewController.detailItem = childViewController.selectedDevice
    }
    
    //MARK - storybord management
    static func getViewController() -> DevicesCombinedVC {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DevicesCombinedVC")
        return controller as! DevicesCombinedVC
    }
    
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DevicesCombinedNavigationVC")
        return controller as! UINavigationController
    }

}
