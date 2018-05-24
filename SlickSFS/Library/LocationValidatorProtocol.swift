//
//  LocationValidatorProtocol.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 6/9/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation
import MapKit

protocol LocationValidatorProtocol {
    
    /** Returns an array of coordinates that will be used to build the validating polygon. Instances need to implement this. */
    func buildCoords() -> [CLLocationCoordinate2D]
    
    /** Returns a polygon based on the coordinates as supplued by buildCoords(). Implemented by default. */
    func buildPolygon() -> MKPolygon
    
    /** Is the supplied CLLocationCoordinate2D within this polygon? Implemented by default. */
    func validateCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool
    
    /** Is the supplied Coordinate within this polygon? Implemented by default. */
    func validateCoordinate(_ coordinate: Coordinate) -> Bool
}

extension LocationValidatorProtocol {
    
    func validateCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let renderer = MKPolygonRenderer(polygon: self.buildPolygon())
        let mapPoint = MKMapPointForCoordinate(coordinate)
        let viewPoint = renderer.point(for: mapPoint)
        return renderer.path.contains(viewPoint)
    }
    
    func validateCoordinate(_ coordinate: Coordinate) -> Bool {
        return validateCoordinate(coordinate.coreLocationCoordinate)
    }
    
    func buildPolygon() -> MKPolygon {
        var coordinates = self.buildCoords()
        return MKPolygon(coordinates: &coordinates, count: coordinates.count)
    }
}
