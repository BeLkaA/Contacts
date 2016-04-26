//
//  Contact.swift
//  Contacts
//
//  Created by Belka_Anton on 19.04.16.
//  Copyright © 2016 Belka_Anton. All rights reserved.
//

import Foundation
import CoreData


class Contact: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var surname: String
    @NSManaged var number: String
    @NSManaged var image: NSData?
// Insert code here to add functionality to your managed object subclass

}
