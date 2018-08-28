//
//  AlarmScheduler.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/28/18.
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
    
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "⏰", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: alarm.name, arguments: nil)
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        
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
    
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
