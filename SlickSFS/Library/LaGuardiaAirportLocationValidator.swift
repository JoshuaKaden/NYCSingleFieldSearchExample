//
//  LaGuardiaAirportLocationValidator.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 6/29/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation
import MapKit

struct LaGuardiaAirportLocationValidator: AirportProtocol {
    
    var mainCoordinate: Coordinate { return Coordinate(latitude: 40.777231565326616, longitude: -73.87235679358152) }
    
    func buildCoords() -> [CLLocationCoordinate2D] {
        let raw: [[Double]] = [
            [-73.8633692,40.7669729],[-73.8586271,40.7667779],[-73.8546896,40.7721569],[-73.8723828,40.7805822],
            [-73.8714092,40.7819551],[-73.8703202,40.7820687],[-73.8691294,40.7833684],[-73.8697091,40.7853505],
            [-73.8713192,40.7861143],[-73.8750906,40.7816281],[-73.8784327,40.7830883],[-73.8794465,40.7818616],
            [-73.8790279,40.7808339],[-73.8852454,40.7802894],[-73.8850309,40.774318],[-73.8877344,40.7738794],
            [-73.8862968,40.768923],[-73.8880348,40.7686061],[-73.8875252,40.7671232],[-73.88546,40.7676595],
            [-73.8821019,40.7691323],[-73.8773543,40.7716084],[-73.8737292,40.7720543],[-73.8711074,40.7716978],
            [-73.8698816,40.77132],[-73.8688087,40.7708274],[-73.8679612,40.7703307],[-73.8664108,40.76931],
            [-73.8633692,40.7669729]
        ]
        return raw.map({ return CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) })
    }
    
    func buildMainLocation() -> Location {
        let addressLines = [
            "LaGuardia Airport"
        ]
        return Location(borough: "Queens", city: "New York", coordinate: mainCoordinate, firstStreetName: "LGA", formattedAddressLines: addressLines, houseNumber: "0", isPreValidated: true, state: "NY", zipCode: "11371")
    }
}
