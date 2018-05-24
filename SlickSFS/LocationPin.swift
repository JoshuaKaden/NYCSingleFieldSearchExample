//
//  LocationPin.swift
//  SlickSFS
//
//  Created by Kaden, Joshua on 5/24/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import MapKit

class LocationPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D { return location.coordinate.coreLocationCoordinate }
    
    var subtitle: String? {
        if location.formattedAddressLines.count > 1 {
            return location.formattedAddressLines[1]
        }
        return nil
    }
    
    var title: String? { return location.formattedAddressLines.first ?? "" }
    
    let location: Location
    
    init(location: Location) {
        self.location = location
    }
}
