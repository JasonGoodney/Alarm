//
//  AlarmsListTableViewController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/25/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

typealias TableViewable = UITableViewDataSource & UITableViewDelegate

class AlarmsListTableViewController: UITableViewController {
    
    let rowHeight: CGFloat = 88
    let cellSegueIdentifier = "ToUpdateDetail"
    
    var alarms: [Alarm] {
        return AlarmController.shared.alarms
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    // MARK: - Actions
    @IBAction func editToggle(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editToggle(_:)))
            hideSwitch()
            
            
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editToggle(_:)))
            showSwitch()
        }
    }
    
    func hideSwitch() {
        guard let cells = tableView.visibleCells as? [SwitchTableViewCell] else { return }
        
        for cell in cells {
            cell.alarmSwitch.isHidden = true
            cell.accessoryType = .disclosureIndicator
        }
    }
    
    func showSwitch() {
        guard let cells = tableView.visibleCells as? [SwitchTableViewCell] else { return }
        
        for cell in cells {
            cell.alarmSwitch.isHidden = false
            cell.accessoryType = .none
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cellSegueIdentifier {
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController,
                  let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.alarm = alarms[index]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.cellId, for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        
        cell.alarm = alarms[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = alarms[indexPath.row]
            AlarmController.shared.delete(alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
}

extension AlarmsListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm else { return }
        
        AlarmController.shared.toggleEnabled(for: alarm)
    }
}


