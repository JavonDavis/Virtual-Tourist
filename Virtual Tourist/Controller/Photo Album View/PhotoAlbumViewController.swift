//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoAlbumNameButton: UIButton!
    @IBOutlet weak var photoAlbumNameTextField: UITextField!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!

    let reuseIdentifier = "PhotoAlbumCollectionViewCell"
    
    var pin: Pin?
    var annotation: MKAnnotation?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.coreDataStack.context // MOC
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        photoAlbumNameTextField.isHidden = true
        
        // Setup CollectionView
        collectionView.delegate = self
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Register Cell class
        collectionView.register(UINib(nibName: "PhotoAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Add annotation to the map and focus on it
        if let annotation = annotation {
            mapView.addAnnotation(annotation)
            focus(mapView: mapView, location: annotation.coordinate)
        }
        
        // Load the pin from the datab
        
        
    }
    
    func loadPin(with annotation: MKPointAnnotation){
        let coordinate = annotation.coordinate
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        
        let pinsFetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        pinsFetchRequest.predicate = predicate
        
        do {
            let fetchedPins = try context.fetch(pinsFetchRequest)
            
            if fetchedPins.count > 0  {
                pin = fetchedPins[0]
                print("Lat:\(pin!.latitude) - lon:\(pin!.longitude)")
            } else {
                print("no pins found")
                self.showAlert(title: "Oops!", message: "There was an error loading this pin from the database")
            }
            
        } catch {
            print("Failed to get Pin")
            print(error.localizedDescription)
            self.showAlert(title: "Oops!", message: "There was an error loading this pin from the database")
        }
        
    }
    
    // MARK:- IBActions
    
    @IBAction func changeName(_ sender: Any) {
    }

    @IBAction func changeAlbum(_ sender: Any) {
        photoAlbumNameButton.isHidden = !photoAlbumNameButton.isHidden
        photoAlbumNameTextField.text = photoAlbumNameButton.titleLabel?.text
        photoAlbumNameTextField.isHidden = !photoAlbumNameTextField.isHidden
    }
    
    @IBAction func loadNewCollection(_ sender: Any) {
    }
}
