//
//  EquationTransformator.swift
//  EquationRecognition
//
//  Created by artur_ios on 06.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//


import SceneKit


class EquationTransformator {
    
    
    // MARK: - Properties
    
    var minX: Float = -1
    var maxX: Float = 1
    var minZ: Float = -1
    var maxZ: Float = 1
    var step: Float = 0.1
    
    
    // MARK: - API Methods
    
    func getPoints(from equation: Equation) -> [Point] {
        switch equation.function {
        case let function as Function2D:
            return getPoints(function)
        case let function as Function3D:
            return getPoints(function)
        case let function as String:
            return getPoints(function)
        default:
            return []
        }
        
//        if let function = equation.function as? Function2D {
//            return getPoints(function)
//        } else if let function = equation.function as? Function3D {
//            return getPoints(function)
//        } else {
//            return []
//        }
    }
    
    
    // MARK: - Private Methods
    
    private func getPoints(_ f: (_ x: Float) -> Float) -> [Point] {
        stride(from: minX, to: maxX, by: step).map { Vector2(x: $0, y: f($0)) }
    }
    
    private func getPoints(_ f: (_ x: Float, _ z: Float) -> Float) -> [Point] {
        var points: [Point] = []
        
        for x in stride(from: minX, to: maxX, by: step) {
            for z in stride(from: minZ, to: maxZ, by: step) {
                let x = Float(x)
                let z = Float(z)
                let vector = Vector3(x: x, y: f(x, z), z: z)
                points.append(vector)
            }
        }
        
        return points
    }
    
    private func getPoints(_ equationString: String) -> [Point] {
        var points: [Point] = []
        
        for x in stride(from: minX, to: maxX, by: step) {
            for z in stride(from: minZ, to: maxZ, by: step) {
                let substitutedEquationString = equationString
                    .replacingOccurrences(of: "x", with: "(\(x))")
                    .replacingOccurrences(of: "z", with: "(\(z))")
                    .replacingOccurrences(of: "^", with: "**")
                guard let y = eval(substitutedEquationString) else { continue }
                points.append(Vector3(x: x, y: Float(y), z: z))
            }
        }
        
        return points
    }
}

