//
//  PhotoAlbum+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import CoreData

@objc(PhotoAlbum)
public class PhotoAlbum: NSManagedObject {

    convenience init(name: String, context: NSManagedObjectContext) {
        
        let entityName = Constants.EntityNames.photoAlbumEntityName
        
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            self.init(entity: entity, insertInto: context)
            self.name = name
            self.createdAt = Date()
            self.updatedAt = Date()
        } else {
            fatalError("Unable to find Entity name: \(entityName)")
        }
        
    }

}
