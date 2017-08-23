//
//  ObservationsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class ObservationsVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var measurementsTableVie: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK - storybord management
    static func getViewController() -> ObservationsVC {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsVC")
        return controller as! ObservationsVC
    }
    
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsNavigatioVC")
        return controller as! UINavigationController
    }

}


// MARK: UITableViewDataSource, UITableViewDelegate
extension ObservationsVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DeviceTableViewCell
        
        //let object = deviceObjects[indexPath.row]
        cell.textLabel!.text = "test"
        //cell.setCell(object)
        return cell
    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        self.selectedDevice = deviceObjects[indexPath.row]
//        
//        if (self.devicesListDelegate == nil) {
//            let vc = DeviceDetailsVC.getViewController()
//            vc.detailItem = selectedDevice
//            navigationController?.pushViewController(vc, animated: true)
//        }
//        else {
//            // delegate not empty - list is embedded with viewController
//            self.devicesListDelegate?.childViewControllerDidPressButton(self)
//        }
//    }
}
