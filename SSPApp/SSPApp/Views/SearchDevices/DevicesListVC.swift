//
//  DevicesListVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 01/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class DevicesListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var detailViewController: DetailViewController? = nil
    var deviceObjects = [SmartDevice]()
    
    let sdm = SearchDevicesManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
    
        NotificationCenter.default.addObserver(self, selector: #selector(notyficationReceived(_:)), name: SymNotificationName.DeviceListLoaded, object: nil)
        sdm.getTestData()
    }
    
    
    //MARK - data management
    func notyficationReceived(_ notification: Notification) {
        let notInfo = NotificationInfo(object: notification.object as AnyObject?)
        log("MasterViewController notification = \(notInfo.infoText)")
        
        if notInfo.errorType == .noErrorSuccessfulFinish {
            //todo
            deviceObjects = sdm.devicesList
            tableView.reloadData()
        }
        else {
            notInfo.showProblemAlert()
        }
    }
    
    

    
    
    
    //MARK - storybord management
    static func getViewController() -> DevicesListVC {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DevicesListVC")
        return controller as! DevicesListVC
    }
    
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DevicesListVC")
        return controller as! UINavigationController
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension DevicesListVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = deviceObjects[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = DeviceDetailsVC.getViewController()
        let deviceObject = deviceObjects[indexPath.row]
        vc.detailItem = deviceObject
        navigationController?.pushViewController(vc, animated: true)
    }
}
