//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 26/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var editPinsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var isDeleting = false

    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Detect Long Taps on the Map
        addLongTapGestureRecogniser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK:- Hide and show Pin Label
    
    func hideEditPinsLabel() {
        self.view.frame.origin.y += editPinsLabel.frame.height
    }
    
    func showEditPinsLabel() {
        self.view.frame.origin.y -= editPinsLabel.frame.height
    }
    
    // MARK:- MapView Long Tap Handler
    
    func addLongTapGestureRecogniser() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleLongTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
    }
    
    // MARK:- Core Data Functions
    
    func fetchPins() {
        let pinsFetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        
    }
    
    func savePin(latitude: Double, longitude: Double) {
        
    }
    
    // MARK:- IBActions

    @IBAction func editPins(_ sender: UIBarButtonItem) {
        
        if isDeleting {
            sender.title = "Edit"
            UIView.animate(withDuration: 0.2, animations: hideEditPinsLabel)
        } else {
            sender.title = "Done"
            UIView.animate(withDuration: 0.2, animations: showEditPinsLabel)
        }
        
        isDeleting = !isDeleting
    }
    
}

