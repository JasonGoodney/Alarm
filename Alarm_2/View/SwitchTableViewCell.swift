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
    
    // MARK: - Properties
    weak var delegate: SwitchTableViewCellDelegate?
    static let cellId = "SwitchTableViewCell"
    var alarm: Alarm? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
}

// MARK: - Update View
private extension SwitchTableViewCell {
    func updateView() {
        if let alarm = alarm {
            nameLabel.text = alarm.name
            timeLabel.text = alarm.fireTimeAsString
            alarmSwitch.isOn = alarm.enabled
        }
    }
}

// MARK: - Methods
private extension SwitchTableViewCell {
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        if let delegate = delegate {
            delegate.switchCellSwitchValueChanged(cell: self)
        }
    }
}

