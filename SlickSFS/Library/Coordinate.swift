//
//  Coordinate.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 1/20/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation
import MapKit

func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

struct Coordinate : Hashable {
    let latitude: Double
    let longitude: Double
    
    var hashValue : Int {
        return latitude.hashValue ^ longitude.hashValue
    }
    
    var coreLocationCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
