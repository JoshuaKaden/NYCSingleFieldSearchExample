//
//  JFKAirportLocationValidator.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 6/29/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

struct JFKAirportLocationValidator: AirportProtocol {
    
    var mainCoordinate: Coordinate { return Coordinate(latitude: 40.64797088837594, longitude: -73.78924813876715) }
    
    func buildCoords() -> [CLLocationCoordinate2D] {
        let raw: [[Double]] = [
            [-73.8235975,40.6546295],[-73.8214302,40.6481502],[-73.7822914,40.6306627],[-73.7888575,40.6227804],
            [-73.7841797,40.6205328],[-73.7779998,40.6274056],[-73.7709618,40.623725],[-73.7721634,40.6206956],
            [-73.7705326,40.6198162],[-73.7659836,40.6281873],[-73.7486457,40.6353525],[-73.7469291,40.6399767],
            [-73.7499332,40.644666],[-73.7836217,40.6629475],[-73.7906277,40.6640136],[-73.7915665,40.6615924],
            [-73.7935807,40.661806],[-73.7937296,40.6645253],[-73.7965286,40.6647216],[-73.7996724,40.6624267],
            [-73.8023331,40.6620442],[-73.8077296,40.6604531],[-73.8185549,40.6612384],[-73.8222671,40.6596757],
            [-73.8235975,40.6546295]
        ]
        return raw.map({ return CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) })
    }
    
    func buildMainLocation() -> Location {
        let addressLines = [
            "JFK Airport"
        ]
        return Location(borough: "Queens", city: "New York", coordinate: mainCoordinate, firstStreetName: "JFK", formattedAddressLines: addressLines, houseNumber: "0", isPreValidated: true, state: "NY", zipCode: "11430")
    }
}
