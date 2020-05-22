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
        (upperBound + lowerBound) / 2
    }
    
    var absDelta: Double {
        abs(delta)
    }
    
    var delta: Double {
        upperBound - lowerBound
    }
    
    init(lower: Double, upper: Double) {
        self.init(uncheckedBounds: (lower: lower, upper: upper))
    }
    
    static func +(_ addition: Double, _ bound: ValuesBounds) -> ValuesBounds {
        ValuesBounds(lower: bound.lowerBound + addition,
                     upper: bound.upperBound + addition)
    }
    
    static func +(_ bound: ValuesBounds, _ addition: Double) -> ValuesBounds {
        addition + bound
    }
    
    static func +=(_ bound: inout ValuesBounds, _ addition: Double) {
        bound = bound + addition
    }
    
    
    static func *(_ multiplier: Double, _ bound: ValuesBounds) -> ValuesBounds {
        ValuesBounds(
            lower: bound.mid - Double(multiplier) * abs(bound.mid - bound.lowerBound),
            upper: bound.mid + Double(multiplier) * abs(bound.mid - bound.upperBound))
    }
    
    static func *(_ bound: ValuesBounds, _ multiplier: Double) -> ValuesBounds {
        multiplier * bound
    }
    
    static func *=(_ bound: inout ValuesBounds, _ multiplier: Double) {
        bound = bound * multiplier
    }
    
    
    static func /(_ bound: ValuesBounds, _ divider: Double) -> ValuesBounds {
        ValuesBounds(
            lower: bound.mid - abs(bound.mid - bound.lowerBound) / Double(divider),
            upper: bound.mid + abs(bound.mid - bound.upperBound) / Double(divider))
    }
    
    static func /=(_ bound: inout ValuesBounds, _ divider: Double) {
        bound = bound / divider
    }
}
