//
//  CGRect extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import CoreGraphics

extension CGRect {
    init(width: CGFloat = 0, height: CGFloat = 0) {
        self.init(x: 0, y: 0, width: width, height: height)
    }
    
    mutating func setWidth(_ newWidth: CGFloat) {
        self = CGRect(x: minX, y: minY, width: newWidth, height: height)
    }
    
    mutating func setHeight(_ newHeight: CGFloat) {
        self = CGRect(x: minX, y: minY, width: width, height: newHeight)
    }
    
    mutating func setMinX(_ x: CGFloat) {
        self = CGRect(x: x, y: minY, width: width, height: height)
    }
    
    mutating func setMinY(_ y: CGFloat) {
        self = CGRect(x: minX, y: y, width: width, height: height)
    }
}
