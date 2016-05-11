//
//  APIHandler.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 11/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIHandler {
    let URL: String
    let APIURLString = "https://data.nasa.gov/resource/y77d-th95.json?$where=year >= '2011-01-01T00:00:00'"
    let headers = ["X-App-Token": "1Es0MN7hsiSHJmhP144nyR6E1"]
    
    init () {
        self.URL = APIURLString.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
    }
    
    func getDataFromAPI(completionHandler: ([Meteorite]?) -> ()) -> () {
        var dataCollection: [Meteorite] = []
        
        Alamofire.request(.GET, self.URL, parameters: [:], headers: headers).responseJSON {
            response in
            if let jsonResponse = response.result.value {
                let json = JSON(jsonResponse)
                
                for (String: _, JSON: subJSON) in json {
                    let name = subJSON["name"].stringValue
                    let mass = subJSON["mass"].stringValue
                    let year = subJSON["year"].stringValue
                    let recclass = subJSON["recclass"].stringValue
                    let id = subJSON["id"].intValue
                    let fall = subJSON["fall"].stringValue
                    let longitude = subJSON["geolocation", "coordinates"][0].doubleValue
                    let latitude  = subJSON["geolocation", "coordinates"][1].doubleValue
                    
                    dataCollection.append(Meteorite(name: name, year: year, mass: mass, id: id, recclass: recclass, longitude: longitude, latitude: latitude, fall: fall))
                }
            }
            
            completionHandler(dataCollection)
        }
    }
}