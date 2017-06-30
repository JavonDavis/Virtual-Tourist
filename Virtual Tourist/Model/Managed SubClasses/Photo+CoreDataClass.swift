//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    convenience init(imageData: NSData, context: NSManagedObjectContext) {
        
        let entityName = Constants.EntityNames.photoEntityName
        
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            self.init(entity: entity, insertInto: context)
            self.imageData = imageData
            self.createdAt = Date()
        } else {
            fatalError("Unable to find Entity name: \(entityName)")
        }
        
    }

}
