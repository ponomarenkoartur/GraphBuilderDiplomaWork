//
//  UILabel extension.swift
//  LimoDad
//
//  Created by artur_ios on 12.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: CGFloat = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(
                NSAttributedString.Key.kern,
                value: kernValue,
                range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
