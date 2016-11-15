//
//  SphericalCoordinates.swift
//  Locator
//
//  Created by Vedad Hasanagic on 11/11/16.
//  Copyright © 2016 VEdad H. All rights reserved.
//

import Foundation

public struct SphericalCoordinates {
    
    fileprivate static let Radius = 6371000.0
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var latitudeRadians: Double  {
        return self.latitude.radians()
    }
    var longitudeRadians: Double {
        return self.longitude.radians()
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(latitudeRadians: Double, longitudeRadians: Double) {
        self.latitude = latitude.degrees()
        self.longitude = longitude.degrees()
    }
    
    func distanceMeters(_ toPoint: SphericalCoordinates) -> Double {
        let φ1 = latitudeRadians
        let φ2 = toPoint.latitudeRadians
        let Δλ = (toPoint.longitude-longitude).radians()
        
        return acos(sin(φ1) * sin(φ2) + cos(φ1) * cos(φ2) * cos(Δλ) ) * SphericalCoordinates.Radius
    }
    
    func distanceKiloMeters(_ toPoint: SphericalCoordinates) -> Double {
        return distanceMeters(toPoint) / 1000.0
    }
    
}


extension SphericalCoordinates {
    
    public static let DublinOffice = SphericalCoordinates(latitude: 53.3393, longitude: -6.2576841)
    
}
