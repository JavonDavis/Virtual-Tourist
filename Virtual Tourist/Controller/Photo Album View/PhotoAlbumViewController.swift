//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoAlbumNameButton: UIButton!
    @IBOutlet weak var photoAlbumNameTextField: UITextField!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!

    let reuseIdentifier = "PhotoAlbumCollectionViewCell"
    
    var pin: Pin?
    
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
    }
    
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
