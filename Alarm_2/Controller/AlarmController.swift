//
//  AlarmController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/25/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        print("Scheduling alarm")
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "⏰", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: alarm.name, arguments: nil)
        content.sound = UNNotificationSound.default()
        
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error adding notification \(error)\n\(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        print("Canceling alarm")
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController {
    
    static let shared = AlarmController()
    
    private init() {}

    var alarms: [Alarm] = []
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
    }
    
    func createAlarm(with name: String, _ fireTimeFromMidnight: TimeInterval) -> Alarm {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        
        saveToPersistance()
        
        return alarm
    }
    
    func update(_ alarm: Alarm, with name: String, _ fireTimeFromMidnight: TimeInterval) {
        alarm.name = name
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        
        saveToPersistance()
    }
    
    func delete(_ alarm: Alarm) {
        if let index = alarms.index(of: alarm) {
            alarms.remove(at: index)
            
            saveToPersistance()
        }
    }
    
    var mockData = [
        Alarm(fireTimeFromMidnight: TimeInterval(), name: "Alarm"),
        Alarm(fireTimeFromMidnight: TimeInterval(), name: "Alarm"),
        Alarm(fireTimeFromMidnight: TimeInterval(), name: "Alarm"),
        Alarm(fireTimeFromMidnight: TimeInterval(), name: "Alarm"),
        
    ]
    
}

extension AlarmController: Persistable {

    typealias LoadData = Alarm
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "alarms.json"
        let documentDirectoryURL = paths[0].appendingPathComponent(fileName)
        return documentDirectoryURL
    }
    
    func saveToPersistance() {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print("\n🤬 Saving alarms error \(error.localizedDescription)\n")
        }
    }
    
    func loadFromPersistance() -> [Alarm] {
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("\n🤬 Loading alarms error \(error.localizedDescription)\n")
        }
        
        return []
    }
    
    
}




