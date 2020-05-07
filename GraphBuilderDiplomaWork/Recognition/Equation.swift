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
        var sortedRangesParameters = self.sortedRangesParameters
        for i in (0..<sortedRangesParameters.count) {
            let rangeParameter = sortedRangesParameters[i]
            let variableName = rangeParameter.parameter.name
            let value = "\(rangeParameter.parameter.value)"
            let subtitutedValueLengthDifference =
                value.count - variableName.count

            let range = rangeParameter.range
            equation = equation.replacingCharacters(in: range, with: value)
                as NSString
            
            sortedRangesParameters
                .map { $0.range }
                .enumerated()
                .forEach { j, range in
                    guard j > i else { return }
                    sortedRangesParameters[j].range.location =
                        range.location + subtitutedValueLengthDifference
                }
        }
        return equation as String
    }
    private(set) var parameters: [PlotEquationParameter] = []
    private var parametersRanges: [PlotEquationParameter: [NSRange]] = [:]
    private var sortedRangesParameters:
        [(range: NSRange, parameter: PlotEquationParameter)] {
        var sortedRangesParameters: [(NSRange, PlotEquationParameter)] = []
        parametersRanges.forEach { (parameter, ranges) in
            sortedRangesParameters.append(contentsOf:
                ranges.map { range in (range, parameter) }
            )
        }
        return sortedRangesParameters.sorted {
            (rangeParameter0: (range: NSRange, PlotEquationParameter),
            rangeParameter1: (range: NSRange, PlotEquationParameter)) -> Bool in
            rangeParameter0.range.location < rangeParameter1.range.location
        }
    }
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
        
        parameters.removeAllExceptIntersect(with: results) {
            $0.name == $1.group
        }
        parametersRanges.removeAllExceptIntersectOfKeys(with: results) {
            $0.name == $1.group
        }
        
        results
            .removingAllIntersection(with: parameters) { $0.group == $1.name }
            .forEach { match in
                let parameter = PlotEquationParameter(
                    name: match.group, value: Self.defaultParameterValue)
                parametersRanges[parameter] =
                    parametersRanges[parameter]?.appending(match.range) ??
                    [match.range]
                parameters.appendIfDoesntContain(parameter)
            }
    }
}
