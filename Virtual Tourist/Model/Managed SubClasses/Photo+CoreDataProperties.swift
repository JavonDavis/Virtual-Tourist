//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 29/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var imageData: NSData?
    @NSManaged public var photoId: String?
    @NSManaged public var photoAlbums: NSSet?

}

// MARK: Generated accessors for photoAlbums
extension Photo {

    @objc(addPhotoAlbumsObject:)
    @NSManaged public func addToPhotoAlbums(_ value: PhotoAlbum)

    @objc(removePhotoAlbumsObject:)
    @NSManaged public func removeFromPhotoAlbums(_ value: PhotoAlbum)

    @objc(addPhotoAlbums:)
    @NSManaged public func addToPhotoAlbums(_ values: NSSet)

    @objc(removePhotoAlbums:)
    @NSManaged public func removeFromPhotoAlbums(_ values: NSSet)

}
