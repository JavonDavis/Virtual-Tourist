//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 29/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var updatedAt: Date?
    @NSManaged public var photoAlbums: NSSet?

}

// MARK: Generated accessors for photoAlbums
extension Pin {

    @objc(addPhotoAlbumsObject:)
    @NSManaged public func addToPhotoAlbums(_ value: PhotoAlbum)

    @objc(removePhotoAlbumsObject:)
    @NSManaged public func removeFromPhotoAlbums(_ value: PhotoAlbum)

    @objc(addPhotoAlbums:)
    @NSManaged public func addToPhotoAlbums(_ values: NSSet)

    @objc(removePhotoAlbums:)
    @NSManaged public func removeFromPhotoAlbums(_ values: NSSet)

}
