//
//  UIViewController+SimpleAlert.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 3/7/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var TOOOk: String { return "Ok" }
    
    @objc func showAlert(message: String) {
        let model = SimpleAlertModel(actionTitle: TOOOk, message: message)
        showAlert(model: model)
    }

    @objc func showAlert(message: String, action: @escaping () -> Void) {
        let model = SimpleAlertModel(action: action, actionTitle: TOOOk, message: message)
        showAlert(model: model)
    }
    
    @objc func showAlert(message: String, title: String) {
        let model = SimpleAlertModel(actionTitle: TOOOk, message: message, title: title)
        showAlert(model: model)
    }
    
    @objc func showAlert(model: SimpleAlertModel) {
        showAlert(model: model, style: .alert)
    }
    
    @objc func showAlert(model: SimpleAlertModel, style: UIAlertControllerStyle = .alert) {
        let controller = UIAlertController(title: model.title, message: model.message, preferredStyle: style)
        
        model.actionModels.forEach {
            actionModel in
            
            let style: UIAlertActionStyle
            switch actionModel.style {
            case .cancel:
                style = .cancel
            case .destructive:
                style = .destructive
            case .standard:
                style = .default
            }
            
            let alertAction = UIAlertAction(title: actionModel.title, style: style, handler: {
                _ in
                actionModel.action()
            })
            
            controller.addAction(alertAction)
        }
        
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}
