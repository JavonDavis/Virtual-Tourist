//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {

    convenience init(latitude: Double, longitde: Double, context: NSManagedObjectContext) {
        
        let entityName = "Pin"
        
        if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
            self.init(entity: entity, insertInto: context)
            self.latitude = latitude
            self.longitude = longitde
            self.createdAt = Date()
            self.updatedAt = Date()
        } else {
            fatalError("Unable to find Entity name: \(entityName)")
        }
        
    }
}
