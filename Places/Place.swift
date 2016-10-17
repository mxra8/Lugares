//
//  Place.swift
//  Places
//
//  Created by Luis on 10/5/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Place : NSManagedObject {
    @NSManaged var name : String
    @NSManaged var type : String
    @NSManaged var location : String
    @NSManaged var image : NSData?
    @NSManaged var rating : String?
    @NSManaged var telephone : String?
    @NSManaged var website : String?
    
    /*
    init(name: String, type: String, location: String, image: UIImage, telephone: String, website: String){
        self.name = name
        self.type = type
        self.location = location
        //self.image = image
        self.telephone = telephone
        self.website = website
    }
 */
}
