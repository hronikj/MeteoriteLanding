//
//  Meteorite.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 07/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation
import CoreLocation

class Meteorite {
    let name: String
    let dateOfImpact: NSDate
    let mass: Float
    let id: Int
    let recclass: String
    let fall: String
    let longitude: Double
    let latitude: Double
    
    init(name: String, year: String, mass: String, id: Int, recclass: String, longitude: Double, latitude: Double, fall: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        
        self.name = name
        self.dateOfImpact = dateFormatter.dateFromString(year)!
        self.mass = NSString(string: mass).floatValue
        self.id = id
        self.recclass = recclass
        self.longitude = longitude
        self.latitude = latitude
        self.fall = fall
    }
}