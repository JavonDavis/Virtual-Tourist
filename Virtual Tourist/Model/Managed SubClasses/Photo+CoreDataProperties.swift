//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
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
    @NSManaged public var pin: PhotoAlbum?

}
