//
//  DetailViewController.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 10/07/2017.
//  Copyright © 2017 Konrad Leszczyński. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var platformNameLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let d = detailItem {
            if let label = detailDescriptionLabel {
                nameLabel.text = d.name
                platformNameLabel.text = d.platformName
                label.text = d.deviceDescription
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

    var detailItem: Device? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

