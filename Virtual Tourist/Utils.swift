//
//  Utils.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import MapKit

// Returns an annotation from a given Pin
func getAnnotation(pin: Pin) -> MKVisualTouristAnnotation {
    
    let lat = CLLocationDegrees(pin.latitude)
    let long = CLLocationDegrees(pin.longitude)
    
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
    let annotation = MKVisualTouristAnnotation()
    annotation.title = "Number of Albums"
    annotation.coordinate = coordinate
    annotation.pin = pin
    
    return annotation
}

// Returns True if the App has launched before, false otherwise
func appHasLaunchedBefore() -> Bool {
    if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
        return true
    } else {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        UserDefaults.standard.synchronize()
        return false
    }
}

// Focuses a mapview onto a specific Location coordinate

func focus(mapView: MKMapView, location: CLLocationCoordinate2D) {
    let latitude = CLLocationDegrees(location.latitude)
    let longitude = CLLocationDegrees(location.longitude)
    let latDelta: CLLocationDegrees = 0.5
    let lonDelta: CLLocationDegrees = 0.5
    let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    mapView.setRegion(region, animated: true)
}
