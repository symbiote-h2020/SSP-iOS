//
//  DeviceTableViewCell.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    //@IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    public func setCell(_ d: SmartDevice) {
        nameLabel.text = d.name
        statusLabel.text = d.status
        if (d.status.uppercased() == "ONLINE") {
            statusLabel.textColor = SSPColors.yes
        }
        else {
            statusLabel.textColor = SSPColors.no
        }
        //platformLabel.text = d.platformName
        typeLabel.text = d.observedProperties.flatMap({$0}).joined(separator: ",");
    }
    
}
