//
//  AlarmsListTableViewController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/25/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class AlarmsListTableViewController: UITableViewController, AlarmScheduler {
    
    // MARK: - Properties
    let rowHeight: CGFloat = 88
    let cellSegueIdentifier = "ToUpdateDetail"
    
    var alarms: [Alarm] {
        return AlarmController.shared.alarms
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

// MARK: - Update View
extension AlarmsListTableViewController {
    func updateView() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: UITableViewDataSource
extension AlarmsListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.cellId, for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.alarm = alarms[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlarmsListTableViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = alarms[indexPath.row]
            AlarmController.shared.delete(alarm)
            cancelUserNotifications(for: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

// MARK: SwitchTableViewCellDelegate
extension AlarmsListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        let alarm = alarms[index]
        
        AlarmController.shared.toggleEnabled(for: alarm)
        
        switch alarm.enabled {
        case true:
            scheduleUserNotifications(for: alarm)
        default:
            cancelUserNotifications(for: alarm)
        }
        
    }
}

// MARK: - Navigation
extension AlarmsListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cellSegueIdentifier {
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController,
                let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.alarm = alarms[index]
            
        }
    }
}
