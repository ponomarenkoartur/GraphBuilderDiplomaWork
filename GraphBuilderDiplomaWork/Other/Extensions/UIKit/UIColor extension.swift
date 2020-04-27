//
//  UIColor extension.swift
//  LimoDad
//
//  Created by artur_ios on 10.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

extension UIColor {
    /// Creates color with rgba componets
    /// - Parameters:
    ///   - r: R component in 0-255 scale
    ///   - g: G component in 0-255 scale
    ///   - b: B component in 0-255 scale
    ///   - alpha: Alpha in 0-1 scale
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(displayP3Red: r / 255, green: g / 255, blue: b / 255,
                  alpha: alpha)
    }
    
    
    /// Creates color with rgba componets
    /// - Parameters:
    ///   - componenets: R, G, B component in 0-255 scale
    ///   - alpha: Alpha in 0-1 scale
    convenience init(_ componets: CGFloat, alpha: CGFloat = 1) {
        self.init(r: componets, g: componets, b: componets)
    }
    
    static func random(withRandomAlpha isRandomAlpha: Bool = false) -> UIColor {
        UIColor(r: CGFloat.random(in: 0...255),
                g: CGFloat.random(in: 0...255),
                b: CGFloat.random(in: 0...255),
                alpha: isRandomAlpha ? CGFloat.random(in: 0...1) : 1)
    }
}
