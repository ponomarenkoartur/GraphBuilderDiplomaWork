//
//  GridBounds.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


struct GridBounds {
    
    var x: ValuesBounds
    var y: ValuesBounds
    var z: ValuesBounds
    
    
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
    
    
    static func /(_ bound: GridBounds, _ divider: Double) -> GridBounds {
        GridBounds(x: bound.x / divider,
                   y: bound.y / divider,
                   z: bound.z / divider)
    }
    
    static func /=(_ bound: inout GridBounds, _ divider: Double) {
        bound = bound / divider
    }
}


// MARK: - CustomStringConvertible

extension GridBounds: CustomStringConvertible {
    var description: String {
        """
        x: (\(x.lowerBound.rounded(toPlaces: 2)), \(x.upperBound.rounded(toPlaces: 2))
        y: (\(y.lowerBound.rounded(toPlaces: 2)), \(y.upperBound.rounded(toPlaces: 2))
        z: (\(z.lowerBound.rounded(toPlaces: 2)), \(z.upperBound.rounded(toPlaces: 2))
        """
    }
}
