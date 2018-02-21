
//
//  Memory.swift
//  Heuristics
//
//  Created by Ahmed Zaghloul on 2/11/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct GeoKey {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    static let identifier = "identifier"
    static let note = "note"
    static let eventType = "eventTYpe"
    static let senderName = "senderName"
}

enum EventType: String {
    case onEntry = "On Entry"
    case onExit = "On Exit"
}

class Geotification: NSObject, NSCoding, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var note: String
    var eventType: EventType
    var senderName:String
    
    var title: String? {
        if note.isEmpty {
            return "No Note"
        }
        return note
    }
    
    var subtitle: String? {
        let eventTypeString = eventType.rawValue
        return "Radius: \(radius)m - \(eventTypeString)"
    }
    
//    convenience init(data:AnyObject){
//        if let data = data as? NSDictionary {
//            let type = EventType(rawValue: data.getValueForKey(key: "eventType", callback: "On Entry"))!
//            let iden = data.getValueForKey(key: "identifier", callback: "")
//            let lat = data.getValueForKey(key: "lat", callback: 0.0)
//            let lng = data.getValueForKey(key: "lng", callback: 0.0)
//            let co = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//            let nt = data.getValueForKey(key: "note", callback: "")
//            let rd = data.getValueForKey(key: "radius", callback: 100)
//
//            self.init(coordinate: co, radius: CLLocationDistance(rd), identifier: iden, note: nt, eventType: type)
//        }
//    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType,senderName:String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
        self.senderName = senderName
    }
    
    // MARK: NSCoding
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDouble(forKey: GeoKey.latitude)
        let longitude = decoder.decodeDouble(forKey: GeoKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: GeoKey.radius)
        identifier = decoder.decodeObject(forKey: GeoKey.identifier) as! String
        note = decoder.decodeObject(forKey: GeoKey.note) as! String
        senderName = decoder.decodeObject(forKey: GeoKey.senderName) as! String
        eventType = EventType(rawValue: decoder.decodeObject(forKey: GeoKey.eventType) as! String)!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: GeoKey.latitude)
        coder.encode(coordinate.longitude, forKey: GeoKey.longitude)
        coder.encode(radius, forKey: GeoKey.radius)
        coder.encode(identifier, forKey: GeoKey.identifier)
        coder.encode(note, forKey: GeoKey.note)
        coder.encode(senderName, forKey: GeoKey.senderName)
        coder.encode(eventType.rawValue, forKey: GeoKey.eventType)
    }
    
}
