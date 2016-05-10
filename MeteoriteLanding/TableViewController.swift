//
//  ViewController.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 06/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
   
    @IBAction func searchAndFilter(sender: UIBarButtonItem) {
        func reload() {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        let optionMenu = UIAlertController(title: nil, message: "Sort by:", preferredStyle: .ActionSheet)
        
        let sortByMassOption = UIAlertAction(title: "Mass", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.sortCollection(.byMass)
            reload()
        })
        
        let sortByYear = UIAlertAction(title: "Year", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.sortCollection(.byYear)
            reload()
        })
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
            // do nothing
        })
        
        optionMenu.addAction(sortByMassOption)
        optionMenu.addAction(sortByYear)
        optionMenu.addAction(cancelOption)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    var meteoriteCollection: [Meteorite] = []
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    enum sortOptions {
        case byYear
        case byMass
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.prepareCache()
        self.getDataFromAPI { (meteoriteCollection) -> Void in
            self.meteoriteCollection = meteoriteCollection!
            self.sortCollection(.byMass)
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sorts the meteorite collection by year
    func sortCollection(options: sortOptions) {
        switch options {
        case .byMass:
            self.meteoriteCollection.sortInPlace({ $0.mass < $1.mass })
            break
        case .byYear:
            self.meteoriteCollection.sortInPlace({ $0.dateOfImpact.compare($1.dateOfImpact) == .OrderedAscending })
            break
        }
        
    }
    
    func isDateToday(date: NSDate) -> Bool {
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
    
    func prepareCache() {
        let memoryCapacity = 500 * 1024 * 1024 // 500 MB
        let diskCapacity = 500 * 1024 * 1024 // 500 MB
        let cache = NSURLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        
        let configuration =  NSURLSessionConfiguration.defaultSessionConfiguration()
        let defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        if let lastUpdate = self.userDefaults.valueForKey("lastUpdate") {
            print("i have last update")
            if isDateToday(lastUpdate as! NSDate) {
                print("date is today so I'm just gonna return the cache")
                // Offline mode: use the cache (no matter how out of date), but don’t load from the network
                configuration.requestCachePolicy = .ReturnCacheDataDontLoad
            } else if Reachability.isConnectedToNetwork() {
                // Don’t use the cache
                print("date is not today and I'm connecte to network, so I'll fetch new data by force")
                configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
                self.userDefaults.setObject(NSDate(), forKey: "lastUpdate")
                self.userDefaults.synchronize()
            } else {
                print("Not connected to network! I'm just gonna return cache!")
                configuration.requestCachePolicy = .ReturnCacheDataDontLoad
            }
        } else if Reachability.isConnectedToNetwork() {
            print("i dont have last update and i have connection so i'll fetch some data")
            // Use the cache (no matter how out of date), or if no cached response exists, load from the network
            configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
            self.userDefaults.setObject(NSDate(), forKey: "lastUpdate")
            self.userDefaults.synchronize()
        } else {
            print("I don't have last update and I don't have connection so i'll just display a warning...")
            let alert = UIAlertController(title: "No Internet Connection!", message: "This App Requires an Internet connection to Load the Data for the First Time. Please Connect to the Internet.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        configuration.URLCache = cache
    }
    
    func getDataFromAPI(completionHandler: ([Meteorite]?) -> ()) -> () {
        var meteoriteCollection: [Meteorite] = []
        if let urlString = String("https://data.nasa.gov/resource/y77d-th95.json?$where=year >= '2011-01-01T00:00:00'").stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()) {
        
            Alamofire.request(.GET, urlString, parameters: [:], headers: ["X-App-Token": "1Es0MN7hsiSHJmhP144nyR6E1"]).responseJSON {
                response in
                if let jsonResponse = response.result.value {
                    let json = JSON(jsonResponse)
                    // print(response.debugDescription)
                    
                    for (String: _, JSON: subJSON) in json {
                        let name = subJSON["name"].stringValue
                        let mass = subJSON["mass"].stringValue
                        let year = subJSON["year"].stringValue
                        let recclass = subJSON["recclass"].stringValue
                        let id = subJSON["id"].intValue
                        let fall = subJSON["fall"].stringValue
                        let longitude = subJSON["geolocation", "coordinates"][0].doubleValue
                        let latitude  = subJSON["geolocation", "coordinates"][1].doubleValue
                        
                        meteoriteCollection.append(Meteorite(name: name, year: year, mass: mass, id: id, recclass: recclass, longitude: longitude, latitude: latitude, fall: fall))
                    }
                }
                
                completionHandler(meteoriteCollection)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meteoriteCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCellIdentifier"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TableViewCell
        let cellData = self.meteoriteCollection[indexPath.row]
        
        cell.nameLabel.text = cellData.name
        cell.massLabel.text = "Mass: " + String(cellData.mass)
        
        let calendar = NSCalendar.currentCalendar()
        let year = calendar.component(NSCalendarUnit.Year, fromDate: cellData.dateOfImpact)
        cell.yearLabel.text = "Year: " + String(year)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegueIdentifier" {
            print("inside segue")
            if let destinationViewController = segue.destinationViewController as? DetailViewController {
                if let selectedCell = sender as? TableViewCell {
                    if let indexPath = tableView.indexPathForCell(selectedCell) {
                        print("passing data")
                        let data = meteoriteCollection[indexPath.row]
                        destinationViewController.id = data.id
                        destinationViewController.longitude = data.longitude
                        destinationViewController.latitude = data.latitude
                        destinationViewController.name = data.name
                        destinationViewController.mass = data.mass
                        destinationViewController.fall = data.fall
                        destinationViewController.year = data.dateOfImpact
                        destinationViewController.recclass = data.recclass
                    }
                }
            }
        }
    }

}

