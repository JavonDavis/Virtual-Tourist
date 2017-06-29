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
    lazy var context: NSManagedObjectContext = self.appDelegate.coreDataStack.context // MOC

    var selectedAnnotation: MKAnnotation?
    var annotations = [MKPointAnnotation]()
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Set default center, if any
        checkMapDefaults()
        
        // Detect Long Taps on the Map
        addLongTapGestureRecogniser()
        
        // Load the pins from PersistentStore
        fetchPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK:- Mapview UserDefaults
    
    func saveCenter(coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
    }
    
    func getCenter() -> CLLocationCoordinate2D {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func checkMapDefaults() {
        if appHasLaunchedBefore() {
            let coordinate = getCenter()
            mapView.setCenter(coordinate, animated: false)
            focus(mapView: mapView, location: coordinate)
        } else {
            saveCenter(coordinate: mapView.centerCoordinate)
        }
    }
    // MARK:- Hide and show Pin Label
    
    func hideEditPinsLabel() {
        self.view.frame.origin.y += editPinsLabel.frame.height
    }
    
    func showEditPinsLabel() {
        self.view.frame.origin.y -= editPinsLabel.frame.height
    }
    
    // MARK:- MapView Functions
    
    func loadPinsOntoMap(pins: [Pin]) {
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
        if gestureRecognizer.state == .ended {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            savePin(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    // MARK:- Core Data Functions
    
    func fetchPins() {
        let pinsFetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            let pins = try context.fetch(pinsFetchRequest) 
            loadPinsOntoMap(pins: pins)
        } catch {
            print("Failed to get Pins")
            print(error.localizedDescription)
            self.showAlert(title: "Oops!", message: "There was an error loading your existing pins")
        }
    }
    
    func savePin(latitude: Double, longitude: Double) {
        let pin = Pin(latitude: latitude, longitde: longitude, context: context)
        let photoAlbum = PhotoAlbum(name: "Photo Album 1", context: context)
        photoAlbum.pin = pin
        
        addPinToMap(pin: pin)
        // TODO: Get Photos in Background
    }
    
    // MARK:- Load Flickr Response 
    
    func parseFlickrResponse(photoObjects: [Dictionary<String, AnyObject>]?, error: Error?) {
        guard error == nil else {
            // Show alert
            return
        }
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
    
    // MARK:- Segue preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoAlbums" {
            let vc = segue.destination as! PhotoAlbumViewController
            vc.annotation = selectedAnnotation
        }
    }
}

