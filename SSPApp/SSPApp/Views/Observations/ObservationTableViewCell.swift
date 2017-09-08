//
//  ObservationTableViewCell.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class ObservationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCell(_ ob: Observation) {
        //self.textLabel!.text = ob.values[0].valueString
        self.textLabel!.text = ob.valuesCombined
    }

}
