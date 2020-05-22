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
        try getPoints(equation.function)
    }
    
    
    // MARK: - Private Methods
    
    private func getPoints(_ f: (_ x: Float) -> Float) -> [Point] {
        stride(from: minX, through: maxX, by: xStep).map {
            Vector2(x: Float($0), y: f(Float($0)))
        }
    }
    
    private func getPoints(_ f: (_ x: Float, _ z: Float) -> Float) -> [Point] {
        var points: [Point] = []
        
        for x in stride(from: minX, through: maxX, by: xStep) {
            for z in stride(from: minZ, through: maxZ, by: zStep) {
                let x = Float(x)
                let z = Float(z)
                let vector = Vector3(x: x, y: f(x, z), z: z)
                points.append(vector)
            }
        }
        
        return points
    }
    
    private func getPoints(_ equationString: String) throws -> [Point?] {
        var points: [Point?] = []
        
        let equationString =
            try convertEquationStringToValidExpression(equationString)
        
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
    
    
    // MARK: - API Methods
    
    func convertEquationStringToValidExpression(
        _ equationString: String) throws -> String {
        guard equationString.countOccurrence(of: "(") ==
            equationString.countOccurrence(of: ")") else {
                throw EvalError.unableToParse
        }
        
        
        var equation = equationString
            .replacingOccurrences(of: "^", with: "**")
        
        let functions = ["sin", "cos", "tan", "cot"]

        for function in functions {
            let stringToFind = "\(function)("
            while equation.contains(stringToFind) {
                let argumentStartIndex =
                    equation.range(of: stringToFind)!.upperBound
                
                var argumentCharacters: [Character] = []
                var bracketCount = 0
                let stringFromArgumentStartToStringEnd =
                    equation[argumentStartIndex..<equation.endIndex]
                
                var offset = 0
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
                    offset += 1
                }
                let argumentEndIndex = equation
                    .index(argumentStartIndex, offsetBy: offset)
                
                let argumentString = String(argumentCharacters)
                
                let uuid = UUID().uuidString
                
                equation.replaceSubrange(
                    argumentStartIndex..<argumentEndIndex, with: uuid)
                
                equation = equation
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

