//
//  Cache.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 11/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation
import Alamofire

class Cache: NSURLCache {
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var cacheLoaded = true
    
    override init() {
        let memoryCapacity = 500 * 1024 * 1024 // 500 MB
        let diskCapacity = 500 * 1024 * 1024   // 500 MB
        let diskPath = "shared_cache"

        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
        
        sessionConfiguration.HTTPAdditionalHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders
        sessionConfiguration.URLCache = self
        
        if let cachePolicy = getAppropriateCachePolicy() {
            sessionConfiguration.requestCachePolicy = cachePolicy
            cacheLoaded = true
        } else {
            cacheLoaded = false
        }
    }
    
    private func isDateToday(date: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Era, .Year, .Month, .Day], fromDate: NSDate())
        let today = calendar.dateFromComponents(components)!
        
        components = calendar.components([.Era, .Year, .Month, .Day], fromDate: date)
        let otherDate = calendar.dateFromComponents(components)!
        
        if (today.isEqualToDate(otherDate)) {
            return true
        }
        
        return false
    }
    
    // Returns appropriate cache policy or nil if there is no connection to network and we don't have last update available
    private func getAppropriateCachePolicy() -> NSURLRequestCachePolicy? {
        func saveLastUpdateToUserDefaults() {
            let userDefaultsKey = "lastUpdate"
            userDefaults.setObject(NSDate(), forKey: userDefaultsKey)
            userDefaults.synchronize()
        }
        
        if let lastUpdate = userDefaults.valueForKey("lastUpdate") {
            if isDateToday(lastUpdate as! NSDate) {
                // date is today so I'm just gonna return the cache
                // Offline mode: use the cache (no matter how out of date), but don’t load from the network
                // configuration.requestCachePolicy = .ReturnCacheDataDontLoad
                return .ReturnCacheDataDontLoad
            } else if Reachability.isConnectedToNetwork() {
                // Don’t use the cache
                // Date is not today and I'm connecte to network, so I'll fetch new data by force
                // configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
                saveLastUpdateToUserDefaults()
                return .ReloadIgnoringLocalCacheData
            } else {
                // Not connected to network! I'm just gonna return cache!
                // configuration.requestCachePolicy = .ReturnCacheDataDontLoad
                return .ReturnCacheDataDontLoad
            }
        } else if Reachability.isConnectedToNetwork() {
            // I dont have last update and i have connection so i'll fetch some data
            // Use the cache (no matter how out of date), or if no cached response exists, load from the network
            // configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
            saveLastUpdateToUserDefaults()
            return .ReloadIgnoringLocalCacheData
        } else {
            // I don't have last update and I don't have connection so i'll just display a warning...
            return nil
        }
    }
}