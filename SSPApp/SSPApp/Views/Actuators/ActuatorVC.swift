//
//  ActuatorVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 06/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import SymAgent

class ActuatorVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var valuesList: [ActuatorsValue] = [ActuatorsValue]()
    var theDevice: SmartDevice? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notyficationReceived(_:)), name: SymNotificationName.ActuatorAction, object: nil)
        
        prepareValuesList()
    }

    func notyficationReceived(_ notification: Notification) {
        let notInfo = NotificationInfo(object: notification.object as AnyObject?)
        log("ActuatorVC notification = \(notInfo.infoText)")
        
        if notInfo.errorType == .noErrorSuccessfulFinish {
            notInfo.showOkAlert()
        }
        else {
            notInfo.showProblemAlert()
        }
    }
    
    func prepareValuesList() {
        if let d = theDevice {
            for op in d.observedProperties {
                let av = ActuatorsValue()
                av.name = op
                valuesList.append(av)
            }
        }
        ///* hardcoded debug test
        let r = ActuatorsValue()
        let g = ActuatorsValue()
        let b = ActuatorsValue()
        r.name = "r"
        g.name = "g"
        b.name = "b"
        valuesList.append(r)
        valuesList.append(g)
        valuesList.append(b)
        /// */
    }
    
    
    //MARK - storybord management
    static func getViewController() -> ActuatorVC {
        let storyboard = UIStoryboard(name: "Actuators", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ActuatorVC")
        return controller as! ActuatorVC
    }
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Actuators", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ActuatorNavigationVC")
        return controller as! UINavigationController
    }
    
    func setSmartDevice(_ device: SmartDevice?) {
        if let sdev = device {
            logVerbose("accturator for device \(sdev.id)")
            theDevice = sdev
        }
        else {
            logError("++++ Smart device for actuatorVC is nil")
        }
    }

    @IBAction func applyButtonTapped(_ sender: Any) {
        if let sdev = self.theDevice {
            let ac = ActuatorManager()
            ac.sendRequest(sdev.id, valuesList: valuesList)
        }
    }
}


// MARK: UITableViewDataSource, UITableViewDelegate
extension ActuatorVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActuatorTableViewCell
        
        let object = valuesList[indexPath.row]
        cell.setCell(object)
        return cell
    }
    
}
