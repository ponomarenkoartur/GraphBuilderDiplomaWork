//
//  UIAlertControllerBuilder.swift
//  U91
//
//  Created by Artur on 5/28/19.
//  Copyright © 2019 pulssoftware. All rights reserved.
//

import UIKit

class AlertBuilder {
    
    // MARK: - Properties
    
    private var alert: UIAlertController

    // MARK: - Initialization
    
    init(title: String? = nil, message: String? = nil) {
        alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
    }
    
    // MARK: - Build Methods
    
    func build() -> UIAlertController {
        return alert
    }
    
    func addTitle(_ title: String?) -> AlertBuilder {
        alert.title = title
        return self
    }
    
    func addMessage(_ message: String?) -> AlertBuilder {
        alert.message = message
        return self
    }
    
    func addButton(title: String?, style: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> ())? = nil)
        -> AlertBuilder {
            let action =
                UIAlertAction(title: title, style: style, handler: handler)
            alert.addAction(action)
            return self
    }
    
    func addOkButton(handler: ((UIAlertAction) -> ())? = nil)
        -> AlertBuilder {
            return addButton(title: "OK", style: .default, handler: handler)
    }
    
    func addCancelButton(handler: ((UIAlertAction) -> ())? = nil) -> AlertBuilder {
        return addButton(title: "Cancel", style: .cancel, handler: handler)
    }
    
    func addDeleteButton(handler: ((UIAlertAction) -> ())? = nil)
        -> AlertBuilder {
            return addButton(title: "Delete", style: .destructive,
                             handler: handler)
    }
}
