//
//  AlarmDetailTableViewController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/26/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {

    private let segueIdentifier = "ToEditName"
    var alarm: Alarm? {
        didSet {
            if isViewLoaded { updateView() }
        }
    }
    let newAlarmSectionCount = 2
    let updateAlarmSectionCount = 4
    let deleteCellSection = 3
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView() {
        guard let alarm = alarm, let fireDate = alarm.fireDate else { return }
        timePicker.setDate(fireDate, animated: false)
        nameTextField.text = alarm.name
        enableSwitch.isOn = alarm.enabled
        
        navigationItem.title = alarm.name
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return alarm != nil ? updateAlarmSectionCount : newAlarmSectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == deleteCellSection {
            guard let alarm = alarm else { return }
            AlarmController.shared.delete(alarm)
            cancelUserNotifications(for: alarm)
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let date = timePicker.date
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            let name = nameTextField.text, !name.isEmpty else { return }
        
        let timeSinceMidnight = date.timeIntervalSince(thisMorningAtMidnight)
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm, with: name, timeSinceMidnight)
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        } else {
            self.alarm = AlarmController.shared.createAlarm(with: name, timeSinceMidnight)
            if let alarm = alarm {
                scheduleUserNotifications(for: alarm)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UISwitch) {
        if let alarm = alarm {
            alarm.enabled = sender.isOn
            
            switch alarm.enabled {
            case true:
                scheduleUserNotifications(for: alarm)
            default:
                cancelUserNotifications(for: alarm)
                
            }
            AlarmController.shared.toggleEnabled(for: alarm)
        }
    }
    
}
