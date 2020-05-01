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
    
    func getPoints(from equation: Equation) throws -> [Point] {
        switch equation.function {
        case let function as Function2D:
            return getPoints(function)
        case let function as Function3D:
            return getPoints(function)
        case let function as String:
            return try getPoints(function)
        default:
            return []
        }
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
    
    private func getPoints(_ equationString: String) throws -> [Point] {
        var points: [Point] = []
        
        let equationString =
            convertEquationStringToValidExpression(equationString)
        
        for x in stride(from: minX, to: maxX, by: step) {
            for z in stride(from: minZ, to: maxZ, by: step) {
                let substitutedEquationString = equationString
                    .replacingOccurrences(of: "x", with: "(\(x))")
                    .replacingOccurrences(of: "z", with: "(\(z))")
                guard let y = try eval(substitutedEquationString) else {
                    continue
                }
                points.append(Vector3(x: x, y: Float(y), z: z))
            }
        }
        
        return points
    }
    
    
    // MARK: - API Methods
    
    func convertEquationStringToValidExpression(
        _ equationString: String) -> String {
        var equation = equationString
            .replacingOccurrences(of: "^", with: "**")
        
        let functions = ["sin", "cos", "tan", "cot"]

        for function in functions {
            let stringToFind = "\(function)("
            while equation.contains(stringToFind) {
                let functionArgumentStartIndex =
                    equation.range(of: stringToFind)!.upperBound
                
                var argumentCharacters: [Character] = []
                var bracketCount = 0
                let stringFromArgumentStartToStringEnd =
                    equation[functionArgumentStartIndex..<equation.endIndex]
                
                for char in stringFromArgumentStartToStringEnd {
                    if char == ")", bracketCount == 0 {
                        break
                    }
                    argumentCharacters.append(char)
                    if char == "(" {
                        bracketCount += 1
                    }
                    if char == ")" {
                        bracketCount -= 1
                    }
                }
                
                let argumentString = String(argumentCharacters)
                
                let uuid = UUID().uuidString
                equation = equation
                    .replacingOccurrences(of: argumentString, with: uuid)
                    .replacingOccurrences(
                        of: "\(function)\\(([^()]+)\\)",
                        with: "function($1, '\(function)')",
                        options: [.regularExpression])
                    .replacingOccurrences(of: uuid, with: argumentString)
            }
        }

        return equation
    }
}

