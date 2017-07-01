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
            let photo = photos[row]
            if photo.imageData == nil {
                FlickrClient.shared.performGetRequestOn(url: photo.url!, with: [:], completion: { data, error in
                    print("Loaded picture from url")
                    if let imageData = data {
                        
                        performUIUpdatesOnMain {
                            photo.imageData = imageData as NSData
                            cell.photoImageView.image = UIImage(data: imageData)
                            cell.loadingIndicator.stopAnimating()
                        }
                    }
                })
            } else {
                cell.photoImageView.image = UIImage(data: photo.imageData! as Data)
                cell.loadingIndicator.stopAnimating()
            }
            
        } else {
            cell.photoImageView.image = UIImage(named: "placeholder")
            cell.loadingIndicator.startAnimating()
        }
        
        return cell
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected")
        
        let row = indexPath.row
        
        if row >= photos.count {
            let alertController = UIAlertController(title: photoAlbum!.name, message: "Image still loading", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let photo = photos[row]
            photos.remove(at: row)
            context.delete(photo)
            appDelegate.coreDataStack.save()
            photoAlbum?.total -= 1
            collectionView.reloadData()
        }
        
        
    }
}
