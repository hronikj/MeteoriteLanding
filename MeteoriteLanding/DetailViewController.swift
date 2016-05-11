//
//  DetailViewController.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 07/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UITableViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var recclassLabel: UILabel!
    @IBOutlet weak var fallLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    var longitude = Double()
    var latitude = Double()
    var id = Int()
    var recclass = String()
    var mass = Float()
    var year = NSDate()
    var fall = String()
    var name = String()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.idLabel.text = String(self.id)
        self.massLabel.text = String(self.mass)
        self.fallLabel.text = self.fall
        self.recclassLabel.text = self.recclass
        self.nameLabel.text = "Name: " + self.name
        
        let calendar = NSCalendar.currentCalendar()
        self.yearLabel.text = String(calendar.component(.Year, fromDate: self.year))
        
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = fontDictionary
        self.title = self.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zoomToRegion(CLLocationCoordinate2DMake(self.latitude, self.longitude))
        self.addAnnotation()
    }
    
    func zoomToRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 150000.0, 100.0)
        mapView.setRegion(region, animated: false)
        
    }
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        annotation.title = self.name
        annotation.subtitle = "Lon: " + String(self.longitude) + " Lat: " + String(self.latitude)
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
}