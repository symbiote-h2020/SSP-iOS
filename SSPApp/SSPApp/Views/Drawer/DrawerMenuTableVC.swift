//
//  DrawerMenuTableVC.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 21/07/2017.
//  Copyright © 2017 PSNC All rights reserved.
//

import UIKit




class DrawerMenuTableVC: UITableViewController {
    
    let options: [DrawerOption] = [.DevicesList, .Settings] //debug, .Search, .Observations, .Chart, .Actuator]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // See https://github.com/sascha/DrawerController/issues/12
        self.navigationController?.view.setNeedsLayout()
        
//        self.tableView.reloadSections(IndexSet(integersIn: NSRange(location: 0, length: self.tableView.numberOfSections - 1).toRange() ?? 0..<0), with: .none)
    }
    
    
    
    //MARK - storybord management
    static func getViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Drawer", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DrawerMenuTableVC")
        return controller
    }
    static func getNavigationViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Drawer", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DrawerMenuNavigationTableVC")
        return controller
    }
    

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(describing: options[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = options[indexPath.row]
        if menuItem == .DevicesList {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let nvc = DevicesCombinedVC.getNavigationViewController()
                self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
            }
            else {
                let nvc = DevicesListVC.getNavigationViewController()
                self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
            }
        }
        else if menuItem == .Settings {
            let nvc = SettingsVC.getNavigationViewController()
            self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
        }
        else if menuItem == .Search {
            let nvc = SearchDevicesVC.getNavigationViewController()
            self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
        }
        else if menuItem == .Observations {
            let nvc = ObservationsVC.getNavigationViewController()
            self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
        }
        else if menuItem == .Chart {
            let nvc = ObservationsChartVC.getNavigationViewController()
            self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
        }
        else if menuItem == .Actuator {
            let nvc = ActuatorVC.getNavigationViewController()
            self.evo_drawerController?.setCenter(nvc, withCloseAnimation: true, completion: nil)
        }
    }
}
