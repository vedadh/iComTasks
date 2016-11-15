//
//  Person.swift
//  Locator
//
//  Created by Vedad Hasanagic on 11/11/16.
//  Copyright © 2016 VEdad H. All rights reserved.
//

import Foundation
import Unbox

struct Person {
    
    let userId: Int
    let name: String
    let location: SphericalCoordinates?
    
    init(userID: Int, name: String, coords: SphericalCoordinates?) {
        self.userId = userID
        self.name = name
        self.location = coords
    }
}

extension Person: Unboxable {
    
    init(unboxer: Unboxer) throws {
        self.userId = try unboxer.unbox(key: "user_id")
        self.name = try unboxer.unbox(key: "name")
        do {
            let lat:Double = try unboxer.unbox(key: "latitude")
            let lon:Double = try unboxer.unbox(key: "longitude")
            self.location = SphericalCoordinates(latitude: lat, longitude: lon)
        }
        
    }
    
}
