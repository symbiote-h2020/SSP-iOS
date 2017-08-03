//
//  MasterViewController.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 03/07/2017.
//  Copyright © 2017 PSNC All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var deviceObjects = [SmartDevice]()

    let sdm = SearchDevicesManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible  //master list always visible on ipad

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notyficationReceived(_:)), name: SymNotificationName.DeviceListLoaded, object: nil)
        sdm.getTestData()
        
        addBackButton()
        //
        //to nie dizła dla split view
    }
    
    func addBackButton() {
        let backButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
        //let vc = SearchDevicesVC.getNavigationViewController()
        //present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
        //show(vc, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = deviceObjects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = deviceObjects[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deviceObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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
    static func getViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "DevicesList", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MasterViewController")
        return controller
    }

    static func getNavigationViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "DevicesList", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MasterViewNavigationController")
        return controller
    }
    
    static func getSplitViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "DevicesList", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SpitViewController")
        return controller
    }
}

