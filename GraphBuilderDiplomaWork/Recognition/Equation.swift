//
//  Equation.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 12.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


struct Equation {
    
    
    // MARK: - Static Constants & Propertiew
    
    private static let parametersRegexString = "(?<=^|\\W)[a-z&&[^xyz]](?=$|\\W)"
    static var defaultParameterValue: Double = 1
    
    
    // MARK: - Properties
    
    private(set) var latex: String
    var function: String {
        var equation = latex as NSString
        var parametersRanges = self.parametersRanges
        for i in (0..<parametersRanges.count) {
            let parameterRange = parametersRanges[i]
            let variableName = parameterRange.parameter.name
            let value = "\(parameterRange.parameter.value)"
            let subtitutedValueLengthDifference =
                value.count - variableName.count

            let range = parameterRange.range
            equation = equation.replacingCharacters(in: range, with: value)
                as NSString
            
            parametersRanges
                .map { $0.range }
                .enumerated()
                .forEach { j, range in
                    guard j > i else { return }
                    parametersRanges[j].range.location =
                        range.location + subtitutedValueLengthDifference
                }
        }
        return equation as String
    }
    var parameters: [PlotEquationParameter] {
        parametersRanges
            .map { $0.parameter }
            .removingDuplicates { $0.name == $1.name }
    }
    private var parametersRanges:
        [(parameter: PlotEquationParameter, range: NSRange)] = []
    private let parametersRegex = try! NSRegularExpression(
        pattern: Self.parametersRegexString)
    
    
    // MARK: - Initialization
    
    init(equation: String) {
        self.latex = equation
        parseParameters()
    }
    
    
    // MARK: - API Methods
    
    mutating func setEquation(_ equation: String) {
        latex = equation
        parseParameters()
    }
    
    
    // MARK: - Private Methods
    
    private mutating func parseParameters() {
        let results = parametersRegex.matches(in: latex)
        
        parametersRanges.removeAllExceptIntersect(with: results) {
            $0.parameter.name == $1.group
        }
        results
            .removingAllIntersection(with: parameters) { $0.group == $1.name }
            .forEach {
                let parameter = PlotEquationParameter(
                    name: $0.group, value: Self.defaultParameterValue)
                parametersRanges.append((parameter, $0.range))
            }
    }
}
