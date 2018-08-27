//
//  AlarmDetailTableViewController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/26/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    private let segueIdentifier = "ToEditName"
    var alarm: Alarm?
    let newAlarmSectionCount = 2
    let updateAlarmSectionCount = 4
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AlarmController.shared.saveToPersistance()
    }
    
    private func updateView() {
        guard let alarm = alarm, let fireDate = alarm.fireDate else { return }
        timePicker.setDate(fireDate, animated: false)
        nameTextField.text = alarm.name
        enableSwitch.isOn = alarm.enabled
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return alarm != nil ? updateAlarmSectionCount : newAlarmSectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let date = timePicker.date
        guard let fireTimeFromMidnight = DateHelper.thisMorningAtMidnight?.timeIntervalSince(date),
            let name = nameTextField.text, !name.isEmpty else { return }
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm, with: name, fireTimeFromMidnight)
        } else {
            AlarmController.shared.createAlarm(with: name, fireTimeFromMidnight)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UISwitch) {
        if let alarm = alarm {
            alarm.enabled = sender.isOn
        }
    }
    
    
}


extension AlarmDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
