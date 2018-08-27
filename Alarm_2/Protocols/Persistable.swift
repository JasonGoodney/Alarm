//
//  Persistable.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/27/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

protocol Persistable {
    
    associatedtype LoadData
    
    func fileURL() -> URL
    func saveToPersistance()
    func loadFromPersistance() -> [LoadData]
}
