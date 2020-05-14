//
//  GridBounds.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


struct GridBounds {
    
    let x: ValuesBounds
    let y: ValuesBounds
    let z: ValuesBounds
    
    
    static func *(_ multiplier: Double, _ bound: GridBounds) -> GridBounds {
        GridBounds(x: multiplier * bound.x,
                   y: multiplier * bound.y,
                   z: multiplier * bound.z)
    }
    
    static func *(_ bound: GridBounds, _ multiplier: Double) -> GridBounds {
        multiplier * bound
    }
    
    static func *=(_ bound: inout GridBounds, _ multiplier: Double) {
        bound = bound * multiplier
    }
}
