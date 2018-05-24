//
//  SimpleAlertModel.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 3/7/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import Foundation

class SimpleAlertModel: NSObject {
    let actionModels: [SimpleAlertActionModel]
    let message: String?
    let title: String?
    
    @objc init(actionModels: [SimpleAlertActionModel], message: String? = nil, title: String? = nil) {
        self.actionModels = actionModels
        self.message = message
        self.title = title
    }
    
    @objc convenience init(action: @escaping (() -> Void), actionTitle: String, message: String) {
        let actionModel = SimpleAlertActionModel(action: action, style: .standard, title: actionTitle)
        self.init(actionModels: [actionModel], message: message, title: nil)
    }
    
    @objc convenience init(actionTitle: String, message: String) {
        self.init(action: {}, actionTitle: actionTitle, message: message)
    }
    
    @objc convenience init(actionTitle: String, message: String, title: String) {
        let actionModel = SimpleAlertActionModel(style: .standard, title: actionTitle)
        self.init(actionModels: [actionModel], message: message, title: title)
    }
}
