//
//  Utils.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import MapKit

func getAnnotation(pin: Pin) -> MKPointAnnotation {
    
    let lat = CLLocationDegrees(pin.latitude)
    let long = CLLocationDegrees(pin.longitude)
    
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    
    return annotation
}
