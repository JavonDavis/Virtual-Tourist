//
//  PhotoAlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 28/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setImage(image: UIImage) {
        loadingIndicator.stopAnimating()
        self.photoImageView.image = image
    }
}
