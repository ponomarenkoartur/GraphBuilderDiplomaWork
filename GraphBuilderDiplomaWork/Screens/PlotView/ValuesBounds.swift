//
//  ValuesBounds.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation

typealias ValuesBounds = ClosedRange<Double>

extension ValuesBounds {
    var mid: Double {
        (self.upperBound + self.lowerBound) / 2
    }
    
    static func *(_ multiplier: Double, _ bound: ValuesBounds) -> ValuesBounds {
        ValuesBounds(uncheckedBounds: (
            lower: bound.mid - Double(multiplier) * abs(bound.mid - bound.lowerBound),
            upper: bound.mid + Double(multiplier) * abs(bound.mid - bound.upperBound)))
    }
    
    static func *(_ bound: ValuesBounds, _ multiplier: Double) -> ValuesBounds {
        multiplier * bound
    }
    
    static func *=(_ bound: inout ValuesBounds, _ multiplier: Double) {
        bound = bound * multiplier
    }
    
    
    static func /(_ bound: ValuesBounds, _ divider: Double) -> ValuesBounds {
        ValuesBounds(uncheckedBounds: (
            lower: bound.mid - abs(bound.mid - bound.lowerBound) / Double(divider),
            upper: bound.mid + abs(bound.mid - bound.upperBound) / Double(divider)))
    }
    
    static func /=(_ bound: inout ValuesBounds, _ divider: Double) {
        bound = bound / divider
    }
}
