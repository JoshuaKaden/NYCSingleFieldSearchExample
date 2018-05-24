//
//  SimpleAlertActionModel.swift
//  ThreeOneOneUnitTests
//
//  Created by Kaden, Joshua on 3/8/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import Foundation

@objc enum SimpleAlertButtonStyle: Int {
    case standard = 0, cancel = 1, destructive = 2
}

class SimpleAlertActionModel: NSObject {
    let action: () -> Void
    let style: SimpleAlertButtonStyle
    let title: String
    
    @objc init(action: @escaping (() -> Void), style: SimpleAlertButtonStyle, title: String) {
        self.action = action
        self.style = style
        self.title = title
    }
    
    @objc convenience init(style: SimpleAlertButtonStyle, title: String) {
        self.init(action: {}, style: style, title: title)
    }
}
