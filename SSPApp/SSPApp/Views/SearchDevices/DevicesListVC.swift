//
//  DevicesListVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 01/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import SymAgent
import SymbioteIosUtils

protocol DevicesListViewControllerDelegate {
    func childViewControllerDidPressButton(_ childViewController:DevicesListVC)
}

class DevicesListVC: ViewControllerWithDrawerMenu {
    
    @IBOutlet weak var tableView: UITableView!
    var deviceObjects = [SmartDevice]()
    var filteredDevices = [SmartDevice]()
    let sdm = SearchDevicesManager()
    var devicesListDelegate: DevicesListViewControllerDelegate?
    var selectedDevice: SmartDevice?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Devices List"
        
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getListNotyficationReceived(_:)), name: SymNotificationName.DeviceListLoaded, object: nil)
        
        sdm.getCoreResourceList()
        sdm.getSSPResourceList()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false //nie chowaj, bo może chcę nawigować do prezentacji danej osoby
        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        searchController.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK Tokens
    func tokenFromSSPNotificationReceived(_ notification: Notification) {
    }
    
    func tokenFromCoreNotificationReceived(_ notification: Notification) {
        let notInfo = NotificationInfo(object: notification.object as AnyObject?)
        
        if notInfo.errorType == .noErrorSuccessfulFinish {
            sdm.getCoreResourceList()
        }
        else {
            notInfo.showProblemAlert()
        }
    }
    
    //MARK - data management
    func getListNotyficationReceived(_ notification: Notification) {
        let notInfo = NotificationInfo(object: notification.object as AnyObject?)
        if notInfo.errorType == .noErrorSuccessfulFinish {
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
        let controller = storyboard.instantiateViewController(withIdentifier: "DevicesListNavigationVC")
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredDevices.count
        }
        return deviceObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DeviceTableViewCell
        
        var object: SmartDevice
        if searchController.isActive && searchController.searchBar.text != "" {
            object = filteredDevices[indexPath.row]
        } else {
            object = deviceObjects[indexPath.row]
        }
        
        cell.setCell(object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if searchController.isActive && searchController.searchBar.text != "" {
            self.selectedDevice = filteredDevices[indexPath.row]
        } else {
            self.selectedDevice = deviceObjects[indexPath.row]
        }
        
        if (self.devicesListDelegate == nil) {
            let vc = DeviceDetailsVC.getViewController()
            vc.detailItem = selectedDevice
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            // delegate not empty - list is embedded with viewController
            self.devicesListDelegate?.childViewControllerDidPressButton(self)
        }
    }
    
    
    // MARK: filter
    
    func filterContentForSearchText(_ text: String, scope: String = "All") {
        let searchText = text.folding(options: .diacriticInsensitive, locale: Locale.current) //remove diacritics
        filteredDevices = self.deviceObjects.filter({( person : SmartDevice) -> Bool in
            return person.name.contains(searchText)  //containsIgnoringCase(searchText)
            
        })
        tableView.reloadData()
    }
}


extension DevicesListVC: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
       filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension DevicesListVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
       filterContentForSearchText(searchController.searchBar.text!)
    }
}
