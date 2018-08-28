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
    private let newAlarmSectionCount = 2
    private let updateAlarmSectionCount = 4
    private let deleteCellSection = 3
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
}

// MARK: - Methods
private extension AlarmDetailTableViewController {
    private func updateView() {
        guard let alarm = alarm else { return }
        
        timePicker.setDate(alarm.fireDate, animated: false)
        nameTextField.text = alarm.name
        enableSwitch.isOn = alarm.enabled
        
        navigationItem.title = alarm.name        
    }
}

// MARK: - Actions
private extension AlarmDetailTableViewController {
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let fireDate = timePicker.date
        let enabled = enableSwitch.isOn
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        if let alarm = alarm {
            //AlarmController.shared.update(alarm, firingAt: fireDate, withName: name)
            let alarmDictionary: [String : Any] = [AlarmKey.name : name, AlarmKey.fireDate : fireDate, AlarmKey.enabled : enabled]
            AlarmController.shared.update(alarm, dictionary: alarmDictionary)
            
        } else {
            let alarmDictionary: [String : Any] = [AlarmKey.name : name, AlarmKey.fireDate : fireDate]
            self.alarm = AlarmController.shared.create(dictionary: alarmDictionary)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UISwitch) {
        if let alarm = alarm {
            alarm.enabled = sender.isOn
            
            AlarmController.shared.toggleEnabled(for: alarm)
        }
    }
}

// MARK: - UITableViewDataSource
extension AlarmDetailTableViewController {
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
}

