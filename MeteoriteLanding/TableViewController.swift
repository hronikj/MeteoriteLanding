//
//  ViewController.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 06/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var meteoriteCollection: MeteoriteCollection = MeteoriteCollection()
    
    @IBAction func searchAndFilter(sender: UIBarButtonItem) {
        func reload() {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        
        let optionMenu = UIAlertController(title: nil, message: "Sort by:", preferredStyle: .ActionSheet)
        
        let sortByMassOption = UIAlertAction(title: "Mass", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.meteoriteCollection.sortCollection(.byMass)
            reload()
        })
        
        let sortByYear = UIAlertAction(title: "Year", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.meteoriteCollection.sortCollection(.byYear)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cache = Cache()
        if !cache.cacheLoaded {
            let alertMessage = "This app requires an internet connection to load the data. Please connect to the Internet."
            let alert = UIAlertController(title: "No Internet Connection!", message: alertMessage, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let apiHandler = APIHandler()
        
        apiHandler.getDataFromAPI { (meteoriteCollection) -> Void in
            self.meteoriteCollection = MeteoriteCollection(meteoriteCollection: meteoriteCollection!)
            self.meteoriteCollection.sortCollection(.byMass)
            self.tableView.reloadData()
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meteoriteCollection.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCellIdentifier"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TableViewCell
        let cellData = self.meteoriteCollection.data[indexPath.row]
        
        cell.nameLabel.text = cellData.name
        cell.massLabel.text = "Mass: " + String(cellData.mass)
        
        let calendar = NSCalendar.currentCalendar()
        let year = calendar.component(NSCalendarUnit.Year, fromDate: cellData.dateOfImpact)
        cell.yearLabel.text = "Year: " + String(year)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegueIdentifier" {
            if let destinationViewController = segue.destinationViewController as? DetailViewController {
                if let selectedCell = sender as? TableViewCell {
                    if let indexPath = tableView.indexPathForCell(selectedCell) {
                        let data = meteoriteCollection.data[indexPath.row]
                        destinationViewController.data = data
                    }
                }
            }
        }
    }

}