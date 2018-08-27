//
//  SwitchTableViewCell.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/25/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    static let cellId = "SwitchTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    var alarm: Alarm? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let alarm = alarm {
            nameLabel.text = alarm.name
            timeLabel.text = alarm.fireTimeAsString
            alarmSwitch.isOn = alarm.enabled
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print("\n switchAlarm.isOn \(sender.isOn)")
        if let delegate = delegate {
            delegate.switchCellSwitchValueChanged(cell: self)
        }
    }
        
}

