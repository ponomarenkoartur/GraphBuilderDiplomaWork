//
//  HandyFunctions.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 04.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


func assignIfNotEqual<T: Equatable>(_ assignee: inout T, _ value: T) {
    if assignee != value {
        assignee = value
    }
}

func assignIfValueIsNotNil<T: Equatable>(_ assignee: inout T, _ value: T?) {
    if let value = value {
        assignee = value
    }
}


// MARK: Scale converter

protocol Boundable {
    associatedtype BoundType
    var lower: BoundType { get }
    var upper: BoundType { get }
}

extension Range: Boundable {
    typealias BoundType = Range.Bound
    var lower: BoundType { lowerBound }
    var upper: BoundType { upperBound }
}

extension ClosedRange: Boundable {
    typealias BoundType = ClosedRange.Bound
    var lower: BoundType { lowerBound }
    var upper: BoundType { upperBound }
}

struct Scale<BoundType>: Boundable {
    var lower, upper: BoundType
}

//
//  minI – min value of initial measurement scale
//  maxI – max value of initial measurement scale
//  minT – min value of target measurement scale
//  maxT – max value of target measurement scale
//
//  iV – value in initial measurement scale
//  tV – value in target measurement scale
//
//                     maxT - minT
//  tV = (iV - minI) * ----------– + minT
//                     maxI - minI
//
func convert<R0: Boundable, R1: Boundable>
    (_ value: Double, from initial: R0, to target: R1) -> Double
    where R0.BoundType == Double, R1.BoundType == Double {
        
    let initialMin = initial.lower
    let initialMax = initial.upper
    let targetMin = target.lower
    let targetMax = target.upper
    
    var result = value - initialMin
    result *= (targetMax - targetMin) / (initialMax - initialMin)
    result += targetMin
    return result
}

func convert<R0: Boundable, R1: Boundable>
    (_ value: Double, from initial: R0, to target: R1) -> Double
    where R0.BoundType == Int, R1.BoundType == Int {    
    convert(
        value,
        from: Scale(lower: Double(initial.lower), upper: Double(initial.upper)),
        to: Scale(lower: Double(target.lower), upper: Double(target.upper)))
}


extension NSNumber: Comparable {
    public static func < (lhs: NSNumber, rhs: NSNumber) -> Bool {
        lhs.doubleValue < rhs.doubleValue
    }
}
