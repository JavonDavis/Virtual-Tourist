//
//  PhotoAlbum+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 30/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import CoreData


extension PhotoAlbum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoAlbum> {
        return NSFetchRequest<PhotoAlbum>(entityName: "PhotoAlbum")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var total: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var photos: NSSet?
    @NSManaged public var pin: Pin?

}

// MARK: Generated accessors for photos
extension PhotoAlbum {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
