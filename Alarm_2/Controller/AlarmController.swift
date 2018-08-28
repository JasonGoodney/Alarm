//
//  AlarmController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/25/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class AlarmController: AlarmScheduler {
    
    static let shared = AlarmController()
    
    private init() {}

    var alarms: [Alarm] = []

}

// MARK: - Methods
extension AlarmController {
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
        switch alarm.enabled {
        case true:
            scheduleUserNotifications(for: alarm)
        default:
            cancelUserNotifications(for: alarm)
        }
    }
}

// MARK: - CRUDable
extension AlarmController: CRUDable {
    typealias Item = Alarm
    
    func create(dictionary: [String : Any]) -> Alarm {
        guard let name = dictionary[AlarmKey.name] as? String,
            let fireDate = dictionary[AlarmKey.fireDate] as? Date else { return Alarm() }
        
        let alarm = Alarm(fireDate: fireDate, name: name)
        alarms.append(alarm)
        scheduleUserNotifications(for: alarm)
        saveToPersistance()
        
        return alarm
    }
    
    func update(_ item: Alarm, dictionary: [String : Any?]) {
        guard let name = dictionary[AlarmKey.name] as? String,
            let fireDate = dictionary[AlarmKey.fireDate] as? Date,
            let enabled = dictionary[AlarmKey.enabled] as? Bool else { return }
        
        item.name = name
        item.fireDate = fireDate
        item.enabled = enabled
        
        cancelUserNotifications(for: item)
        scheduleUserNotifications(for: item)
        
        saveToPersistance()
    }
    
    func delete(_ item: Alarm) {
        if let index = alarms.index(of: item) {
            alarms.remove(at: index)
            
            cancelUserNotifications(for: item)
            saveToPersistance()
        }
    }
}

// MARK: - Persistable
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




