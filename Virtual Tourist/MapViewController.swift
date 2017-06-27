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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.coreDataStack.context

    var annotations = [MKPointAnnotation]()
    
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
    
    // MARK:- MapView Functions
    
    func loadPins(pins: [Pin]) {
        mapView.removeAnnotations(annotations)
        for pin in pins {
            addPinToMap(pin: pin)
        }
    }
    
    func addPinToMap(pin: Pin) {
        self.mapView.addAnnotation(getAnnotation(pin: pin))
    }
    
    func removePinFromMap(annotation: MKPointAnnotation) {
        self.mapView.removeAnnotation(annotation)
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
        
        do {
            let pins = try context.fetch(pinsFetchRequest) 
            loadPins(pins: pins)
        } catch {
            print("Failed to get Pins")
            print(error.localizedDescription)
            self.showAlert(title: "Oops!", message: "There was an error loading your existing pins")
        }
    }
    
    func savePin(latitude: Double, longitude: Double) {
        let pin = Pin(latitude: latitude, longitde: longitude, context: context)
        addPinToMap(pin: pin)
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

