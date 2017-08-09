//
//  DeviceDetailsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 01/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class DeviceDetailsVC: UIViewController {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var platformNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let d = detailItem {
            if let l = nameLabel {
                l.text = d.name
            }
            if let p = platformNameLabel {
                p.text = d.platformName
            }
            if let dL = descriptionLabel {
                dL.text = d.deviceDescription
            }
            if let lL = locationLabel {
                lL.text = d.locationName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        setupGui()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: SmartDevice? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func setupGui() {
        
    }
    
    
    
    //MARK - storybord management
    static func getViewController() -> DeviceDetailsVC {
        let storyboard = UIStoryboard(name: "SearchDevices", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DeviceDetailsVC")
        return controller as! DeviceDetailsVC
    }

}
