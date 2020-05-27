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
    
    var xBounds: ValuesBounds = -1...1
    var yBounds: ValuesBounds = -1...1
    var zBounds: ValuesBounds = -1...1
    var minX: Double { xBounds.lower }
    var maxX: Double { xBounds.upper }
    var minY: Double { yBounds.lower }
    var maxY: Double { yBounds.upper }
    var minZ: Double { zBounds.lower }
    var maxZ: Double { zBounds.upper }
    private var xStep: Double {
        abs((maxX - minX) / 20)
    }
    private var zStep: Double {
        abs((maxZ - minZ) / 20)
    }
    
    
    // MARK: - API Methods
    
    func getPoints(from equation: Equation) throws -> [Point?] {
        guard let function = equation.function else {
            throw EvalError.unableToParse
        }
        return try getPoints(function)
    }
    
    
    // MARK: - Private Methods
    
    private func getPoints(_ equationString: String) throws -> [Point?] {
        var points: [Point?] = []
        for x in stride(from: minX, through: maxX, by: xStep) {
            for z in stride(from: minZ, through: maxZ, by: zStep) {
                let substitutedEquationString = equationString
                    .replacingOccurrences(of: "x", with: "(\(x))")
                    .replacingOccurrences(of: "z", with: "(\(z))")
                guard let y = try eval(substitutedEquationString) else {
                    points.append(nil)
                    continue
                }
                points.append(Vector3(x: Float(x), y: Float(y), z: Float(z)))
            }
        }
        
        return points
    }
}


// MARK: - GridBoundable

extension EquationTransformator: GridBoundable {
    func setBounds(x: ValuesBounds? = nil, y: ValuesBounds? = nil,
                   z: ValuesBounds? = nil) {
        if let x = x {
            xBounds = x
        }
        if let y = y {
            yBounds = y
        }
        if let z = z {
            zBounds = z
        }
    }
}

