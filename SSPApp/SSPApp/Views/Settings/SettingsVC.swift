//
//  SettingsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 19/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class SettingsVC: ViewControllerWithDrawerMenu {
    
    @IBOutlet weak var endpointUrlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endpointUrlTextField.text = Constants.restApiUrl
        
        NotificationCenter.default.addObserver(self, selector: #selector(notyficationReceived(_:)), name: SymNotificationName.Settings, object: nil)
    }
    
    func notyficationReceived(_ notification: Notification) {
        let notInfo = NotificationInfo(object: notification.object as AnyObject?)
        log("SettingsVC notification = \(notInfo.infoText)")
        
        if notInfo.errorType == .noErrorSuccessfulFinish {
            notInfo.showOkAlert()
            
            //debug - close app
            exit(0);
        }
        else {
            notInfo.showProblemAlert()
        }
    }
    
    
    
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        let stMan = SettingsManager()
        stMan.allSettings.restApiUrl = endpointUrlTextField.text!
        stMan.saveSettings()
    }
    
    
    //MARK - storybord management
    static func getViewController() -> SettingsVC {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        return controller as! SettingsVC
    }
    
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationVC")
        return controller as! UINavigationController
    }
    

}