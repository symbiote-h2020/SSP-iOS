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
    static func getViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchDevicesVC")
        return controller
    }
    
    
    static func getNavigationViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchDevicesNavigationVC")
        return controller
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //navigate
    @IBAction func searchButtonTapped(_ sender: Any) {
        //let mvc = MasterViewController.getNavigationViewController()
        //present(mvc, animated: true, completion: nil)
        //show(mvc, sender: self)
       //tak sie sypie navigationController?.pushViewController(mvc, animated: true)
        let vc = MasterViewController.getViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    

}
