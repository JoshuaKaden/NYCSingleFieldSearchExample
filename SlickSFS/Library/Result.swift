//
//  Result.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 1/20/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(NSError)
}
