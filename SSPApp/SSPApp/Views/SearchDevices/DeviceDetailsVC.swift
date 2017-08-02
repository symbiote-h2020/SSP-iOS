//
//  DeviceDetailsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 01/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class DeviceDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //MARK - storybord management
    static func getViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeviceDetailsVC")
        return controller
    }
    
    
    static func getNavigationViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeviceDetailsVC")
        return controller
    }

}
