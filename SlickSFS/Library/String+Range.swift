//
//  String+Range.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 1/8/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

extension String {
    func stringByTrimmingExtraneousWhitespace() -> String {
        let words = self.components(separatedBy: CharacterSet.whitespaces).filter({ !$0.isEmpty })
        return words.joined(separator: " ")
    }
}
