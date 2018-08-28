//
//  CRUDable.swift
//  Alarm_2
//
//  Created by Jason Goodney on 8/27/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

protocol CRUDable {
    
    associatedtype Item
    
    func create(dictionary: [String : Any]) -> Item
    func update(_ item: Item, dictionary: [String : Any?])
    func delete(_ item: Item)
    
}
