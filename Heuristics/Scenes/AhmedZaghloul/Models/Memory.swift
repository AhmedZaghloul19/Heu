//
//  Memory.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/11/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import Foundation

class Memory: BaseModel {
    
    var status:String?
    var time:String?
    var location:Location?
    
    override init(data: AnyObject) {
        super.init(data: data)
        if let data = data as? NSDictionary {
            print(data)
            status = data.getValueForKey(key: "status", callback: "")
            location = Location(data: data.getValueForKey(key: "location", callback: [:]) as AnyObject)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let dateStr = data.getValueForKey(key: "time", callback: Date().getStringFromDate())
            guard let date = dateFormatter.date(from: dateStr) else {
                return
            }
            time = date.getElapsedInterval()
        }
    }
}

class Location {
    var lat:Double?
    var lng:Double?
    var name:String?
    
    init(data:AnyObject) {
        if let data = data as? NSDictionary {
            lat = data.getValueForKey(key: "lat", callback: 0.0)
            lng = data.getValueForKey(key: "lng", callback: 0.0)
            name = data.getValueForKey(key: "name", callback: "")
        }
    }
}
