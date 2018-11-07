//
//  ActuatorTableViewCell.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 12/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import SymAgent
import SymbioteIosUtils

class ActuatorTableViewCell: UITableViewCell {

    var theValue: ActuatorsValue?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ av: ActuatorsValue) {
        theValue = av
        nameLabel.text = av.name
        if av.name == "rele" || av.name == "relay" {
            setOnOffType()
        }
        else {
            setRangeType()
        }
    }

    func setOnOffType() {
        if let av = theValue {
            slider.isHidden = true
            valueLabel.isHidden = true
            valueSwitch.isHidden = false
            
            
            av.maxValue = 1
            av.minValue = 0
            av.value = 0
        }
    }
    
    func setRangeType() {
        if let av = theValue {
            slider.isHidden = false
            valueLabel.isHidden = false
            valueSwitch.isHidden = true
            
            
            slider.minimumValue = Float(av.minValue)
            slider.maximumValue = Float(av.maxValue)
            slider.value = Float(av.value)
            valueLabel.text = String(av.value)
        }
    }
    
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let val = Int(slider.value)
        valueLabel.text = String(val)
        theValue?.value = val
    }
    
    
    @IBAction func valueSwitchChanged(_ sender: Any) {
        var val = 0
        
        if valueSwitch.isOn {
            val = 1
        }
        
        valueLabel.text = String(val)
        theValue?.value = val

    }
    
}
