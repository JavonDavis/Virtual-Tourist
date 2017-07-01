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
    var photoAlbum: PhotoAlbum?
    var photos = [Photo]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.coreDataStack.context // MOC
     
    
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Map
        
        mapView.delegate = self
        
        photoAlbumNameTextField.isHidden = true
        photoAlbumNameTextField.delegate = self
        
        // Setup CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Register Custom Cell class
        collectionView.register(UINib(nibName: "PhotoAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Add annotation to the map and focus on it
        if let pin = pin {
            let annotation = getAnnotationFromPin(pin: pin)
            mapView.addAnnotation(annotation)
            focus(mapView: mapView, location: annotation.coordinate)
        }
    }
    
    func setupPhotoAlbum() {
        // Setup Button and TextField
        if let photoAlbum = photoAlbum {
            photoAlbumNameButton.setTitle(photoAlbum.name, for: .normal)
            photoAlbumNameTextField.text = photoAlbum.name
        } else {
            let photoAlbums = pin?.photoAlbums?.allObjects as! [PhotoAlbum]
            photoAlbum = photoAlbums[0]
            photoAlbumNameButton.setTitle(photoAlbum!.name, for: .normal)
            photoAlbumNameTextField.text = photoAlbum!.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Setup Button and TextField
        setupPhotoAlbum()
        
        let photoCount = Int((photoAlbum?.total)!)
        
        guard photoCount > 0 else {
            self.showAlert(title: "No Photos!", message: "Sorry we have no photos for this area")
            return
        }
        
        fetchPhotos()
    }
    
    // MARK:- Core Data Function
    
    func createPhotosFromURLs(urls: [String]?, error: Error?) {
        guard error == nil else {
            self.showAlert(title: "Error loading Photos from Server", message: "There was an error dowloading photos for this pin.")
            return
        }
        
        let numberOfPhotos = min(21, urls!.count)
        let randomURLs = urls!.choose(Int(numberOfPhotos))
        
        for url in randomURLs {
            
            photoAlbum!.total = Int16(numberOfPhotos)

            let photo = Photo(url: url, context: context)
            photo.photoAlbum = photoAlbum
            photos.append(photo)
        }
        collectionView.reloadData()
    }
    
    func fetchPhotos() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        let predicate = NSPredicate(format: "photoAlbum = %@", argumentArray: [photoAlbum!])
        fetchRequest.predicate = predicate
        
        do {
            photos = try context.fetch(fetchRequest)
            
            if photoAlbum!.photos!.count != Int((photoAlbum?.total)!) { // Discrepany in the number of photos that should be there and what is actually there
                FlickrClient.shared.loadImageURLs(pin: pin!, completion: createPhotosFromURLs)
            }
            collectionView.reloadData()
        } catch {
            print("Failed to get Photos")
            print(error.localizedDescription)
            self.showAlert(title: "Oops!", message: "There was an error loading your photos")
        }
    }
    func saveAlbumName() {
        let name = photoAlbumNameTextField.text
        
        guard name != "" else {
            self.showAlert(title: "Name cannot be empty", message: "Album name cannot be empty")
            return
        }
        photoAlbum?.name = name
        photoAlbum?.updatedAt = Date()
        pin?.updatedAt = Date()
        
        photoAlbumNameButton.isHidden = !photoAlbumNameButton.isHidden
        photoAlbumNameButton.setTitle(name, for: .normal)
        photoAlbumNameTextField.isHidden = !photoAlbumNameTextField.isHidden
    }
    
    func deletePhotos() {
        for photo in photos {
            context.delete(photo)
        }
        appDelegate.coreDataStack.save()
        photos = []
    }
    // MARK:- IBActions
    
    @IBAction func changeName(_ sender: Any) {
        photoAlbumNameButton.isHidden = !photoAlbumNameButton.isHidden
        photoAlbumNameTextField.text = photoAlbumNameButton.titleLabel?.text
        photoAlbumNameTextField.isHidden = !photoAlbumNameTextField.isHidden
    }

    @IBAction func changeAlbum(_ sender: Any) {
        performSegue(withIdentifier: "showAllAlbums", sender: self)
    }
    
    @IBAction func loadNewCollection() {
        deletePhotos()
        
        fetchPhotos()
    }
    
    // MARK:- Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllAlbums" {
            if let vc = segue.destination as? AlbumsTableViewController {
                vc.photoAlbumDelegate = self // Set the delegate for receiving info from child vc
                
                // Pass the vc data about the current view
                vc.pin = pin
                vc.currentAlbum = photoAlbum
            }
        }
    }
}

// MARK:- PhotoAlbumNameTextField delegate

extension PhotoAlbumViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveAlbumName()
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- PhotoAlbum Delegat see AlbumsViewController for definition

extension PhotoAlbumViewController: PhotoAlbumDelegate {
    
    func setAlbum(album: PhotoAlbum?) {
        photoAlbum = album
    }
}
