//
//  PersonDetailCell.swift
//  Locator
//
//  Created by Vedad Hasanagic on 11/11/16.
//  Copyright © 2016 VEdad H. All rights reserved.
//

import UIKit

class PersonDetailCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    func render(person: Person) {
        self.name.text = person.name
        
        self.distance.text = String(format: "%.1f km", (person.location?.distanceKiloMeters(SphericalCoordinates.DublinOffice))!)
    }
    
}
