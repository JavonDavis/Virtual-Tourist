//
//  MapViewController+MapViewDelegate.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard !isDeleting else {
            print("Deleting Pin")
            
            let annotation = view.annotation as! MKVisualTouristAnnotation
            let pin = annotation.pin!
            
            context.delete(pin)
            mapView.removeAnnotation(annotation)
            return
        }
        print("Pin Tapped")
        
        selectedAnnotation = view.annotation
        
        performSegue(withIdentifier: "showPhotoAlbums", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveCenter(coordinate: mapView.centerCoordinate)
    }
    
}
