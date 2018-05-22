//
//  Location.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 1/20/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

func ==(lhs: Location, rhs: Location) -> Bool {
    return
        lhs.houseNumber == rhs.houseNumber &&
        lhs.firstStreetName == rhs.firstStreetName &&
        lhs.secondStreetName == rhs.secondStreetName &&
        lhs.borough == rhs.borough &&
        lhs.coordinate == rhs.coordinate &&
        lhs.zipCode == rhs.zipCode &&
        lhs.formattedAddressLines == rhs.formattedAddressLines &&
        lhs.city == rhs.city &&
        lhs.state == lhs.state &&
        lhs.country == rhs.country &&
        lhs.name == rhs.name
}

struct Location : Hashable {
    let houseNumber: String
    let firstStreetName: String
    let secondStreetName: String
    let borough: String
    let coordinate: Coordinate
    let zipCode: String
    let formattedAddressLines: [String]
    let city: String
    let state: String
    let country: String
    let isPreValidated: Bool
    let name: String
    
    var isIntersection: Bool { return houseNumber.isEmpty && !firstStreetName.isEmpty && !secondStreetName.isEmpty }
    
    var hashValue: Int {
        return houseNumber.hashValue ^ firstStreetName.hashValue ^ secondStreetName.hashValue ^ borough.hashValue ^ coordinate.hashValue ^ zipCode.hashValue ^ city.hashValue ^ state.hashValue ^ country.hashValue ^ name.hashValue
    }
    
    var isEmpty: Bool {
        return houseNumber.isEmpty && firstStreetName.isEmpty && secondStreetName.isEmpty && borough.isEmpty && coordinate.latitude == 0 && coordinate.longitude == 0 && zipCode.isEmpty && formattedAddressLines.isEmpty && city.isEmpty && state.isEmpty && country.isEmpty && name.isEmpty
    }
    
    init(borough: String = "", city: String = "", coordinate: Coordinate = Coordinate(latitude: 0, longitude: 0), country: String = "", firstStreetName: String = "", formattedAddressLines: [String] = [], houseNumber: String = "", isPreValidated: Bool = false, name: String = "", secondStreetName: String = "", state: String = "", zipCode: String = "") {
        self.houseNumber = houseNumber.stringByTrimmingExtraneousWhitespace()
        self.firstStreetName = firstStreetName.stringByTrimmingExtraneousWhitespace()
        self.secondStreetName = secondStreetName.stringByTrimmingExtraneousWhitespace()
        self.borough = borough.stringByTrimmingExtraneousWhitespace()
        self.coordinate = coordinate
        self.zipCode = zipCode.stringByTrimmingExtraneousWhitespace()
        self.formattedAddressLines = formattedAddressLines
        self.city = city.stringByTrimmingExtraneousWhitespace()
        self.state = state.stringByTrimmingExtraneousWhitespace()
        self.country = country.stringByTrimmingExtraneousWhitespace()
        self.isPreValidated = isPreValidated
        self.name = name.stringByTrimmingExtraneousWhitespace()
    }
}
