//
//  Locateable.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 6/29/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

protocol Locateable {
    var mainCoordinate: Coordinate { get }
    /** Returns a Location construct that represents a center, or main, location. Instances need to implement this. */
    func buildMainLocation() -> Location
}
