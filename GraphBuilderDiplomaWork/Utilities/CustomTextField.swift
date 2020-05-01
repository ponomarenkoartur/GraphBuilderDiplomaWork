//
//  CustomTextField.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    
    // MARK: - Properties

    @IBInspectable var isPasteEnabled: Bool = true

    @IBInspectable var isSelectEnabled: Bool = true

    @IBInspectable var isSelectAllEnabled: Bool = true

    @IBInspectable var isCopyEnabled: Bool = true

    @IBInspectable var isCutEnabled: Bool = true

    @IBInspectable var isDeleteEnabled: Bool = true
    
    
    // MARK: - Other Methods

    override func canPerformAction(
        _ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
             #selector(UIResponderStandardEditActions.select(_:)) where !isSelectEnabled,
             #selector(UIResponderStandardEditActions.selectAll(_:)) where !isSelectAllEnabled,
             #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
             #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
             #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
}
