//
//  AlarmController.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/25/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class AlarmController {
    
    static let shared = AlarmController()
    
    private init() {}

    var alarms: [Alarm] = []
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
    }
    
    func createAlarm(with name: String, _ fireTimeFromMidnight: TimeInterval) {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        
        saveToPersistance()
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




