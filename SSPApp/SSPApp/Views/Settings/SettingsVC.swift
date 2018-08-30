//
//  SettingsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 19/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import SymAgent
import SymbioteIosUtils

class SettingsVC: ViewControllerWithDrawerMenu {
    
    @IBOutlet weak var endpointUrlTextField: UITextField!
    @IBOutlet weak var coreInterfaceUelTextField: UITextField!
    @IBOutlet weak var coreClientQueryTextField: UITextField!
    @IBOutlet weak var coreResourceRequestTemplateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endpointUrlTextField.text = GlobalSettings.restApiUrl
        coreInterfaceUelTextField.text = GlobalSettings.coreInterfaceApiUrl
        coreClientQueryTextField.text = GlobalSettings.coreClientRequest
        coreResourceRequestTemplateTextField.text = GlobalSettings.coreRapSensorAdressTamplate
        
        //hiding keyboard
        endpointUrlTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notyficationReceived(_:)), name: SymNotificationName.Settings, object: nil)
    }
    
    func notyficationReceived(_ notification: Notification) {
        let notInfo = NotificationInfo(object: notification.object as AnyObject?)
        log("SettingsVC notification = \(notInfo.infoText)")
        
        if notInfo.errorType == .noErrorSuccessfulFinish {
            notInfo.showOkAlert()
            
            //debug - close app - to make sure everything is working
            exit(0);
            //TODO: proper refreshment of list
        }
        else {
            notInfo.showProblemAlert()
        }
    }
    
    
    
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        let stMan = SettingsManager()
        stMan.allSettings.restApiUrl = endpointUrlTextField.text!
        stMan.allSettings.coreInterfaceApi = coreInterfaceUelTextField.text!
        
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

//MARK - hiding keyboard
extension SettingsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
