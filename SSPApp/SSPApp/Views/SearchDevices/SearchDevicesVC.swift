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
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.title = "zupa"
//        let navigationBar = navigationController!.navigationBar
//        navigationBar.tintColor = UIColor.blue
//        
//        let leftButton =  UIBarButtonItem(title: "Left Button", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//        let rightButton = UIBarButtonItem(title: "Right Button", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//        
//        navigationItem.leftBarButtonItem = leftButton
//        navigationItem.rightBarButtonItem = rightButton
//        // Do any additional setup after loading the view.
//    }

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

}
