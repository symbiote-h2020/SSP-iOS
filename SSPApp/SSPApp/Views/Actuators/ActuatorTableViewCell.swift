//
//  ActuatorTableViewCell.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 12/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class ActuatorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ str: String) {
        nameLabel.text = str
    }

}
