//
//  DetailViewController.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 10/07/2017.
//  Copyright © 2017 Konrad Leszczyński. All rights reserved.
//

import UIKit
import SymAgent

@available(*, deprecated)
class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
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


}

