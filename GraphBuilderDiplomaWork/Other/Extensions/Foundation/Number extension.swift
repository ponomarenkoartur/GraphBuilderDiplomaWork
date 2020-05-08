//
//  Number extension.swift
//  FurnitureMeasureSample
//
//  Created by Artur on 2/20/19.
//  Copyright © 2019 artur_ios. All rights reserved.
//

import UIKit
import Foundation

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    func rounded(toPlaces places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}


extension Float {
    var toPositiveAngleInDegrees: Float {
        var angle = fmod(self, 360.0)
        if (angle < 0) {
            angle += 360
        }
        return angle
    }
    var toPositiveAngleInRadians: Float {
        return self.radiansToDegrees.toPositiveAngleInDegrees.degreesToRadians
    }
}

extension NSNumber {
    var isInteger: Bool { NSNumber(value: intValue) == self }
}

