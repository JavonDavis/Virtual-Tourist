//
//  PhotoAlbumViewController+CollectionViewDelegate.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 28/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(photoAlbum!.total)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        
        let row = indexPath.row
        
        if row < photos.count {
            cell.loadingIndicator.stopAnimating()
            let photo = photos[row]
            cell.photoImageView.image = UIImage(data: photo.imageData! as Data)
        } else {
            cell.loadingIndicator.startAnimating()
        }
        
        return cell
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected")
        
        let row = indexPath.row
        
        if row < photos.count {
            let alertController = UIAlertController(title: photoAlbum!.name, message: "", preferredStyle: .alert)
            let photo = photos[row]
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imageView.contentMode = .center
            imageView.image = UIImage(data: photo.imageData! as Data)
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: photoAlbum!.name, message: "Image still loading", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
        }
        
        
    }
}
