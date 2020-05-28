//
//  CGSize extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import CoreGraphics


extension CGSize {
    init(sideLength: CGFloat) {
        self.init(width: sideLength, height: sideLength)
    }
    
    /// Aspect ratio of height to width
    var aspectRatio: CGFloat {
        height / width
    }
}
