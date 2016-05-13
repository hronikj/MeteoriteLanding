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
    
    var data = Meteorite()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.idLabel.text = String(self.data.id)
        self.massLabel.text = String(self.data.mass)
        self.fallLabel.text = self.data.fall
        self.recclassLabel.text = self.data.recclass
        self.nameLabel.text = "Name: " + self.data.name
        
        let calendar = NSCalendar.currentCalendar()
        self.yearLabel.text = String(calendar.component(.Year, fromDate: self.data.dateOfImpact))
        
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = fontDictionary
        self.title = self.data.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.zoomToRegion(CLLocationCoordinate2DMake(self.data.latitude, self.data.longitude))
        self.addAnnotation()
    }
    
    func zoomToRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 150000.0, 100.0)
        mapView.setRegion(region, animated: false)
        
    }
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(self.data.latitude, self.data.longitude)
        annotation.title = self.data.name
        annotation.subtitle = "Lon: " + String(self.data.longitude) + " Lat: " + String(self.data.latitude)
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
}