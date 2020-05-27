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
    var function: String?
    
    private var parametersRanges: [(parameter: EquationParameter, ranges: [NSRange])] = []
    var parameters: [EquationParameter] {
        parametersRanges
            .map { $0.parameter }
            .removingDuplicates()
    }
    private var sortedRangesParameters:
        [(range: NSRange, parameter: EquationParameter)] {
        var sortedRangesParameters: [(NSRange, EquationParameter)] = []
        parametersRanges.forEach { (parameter, ranges) in
            sortedRangesParameters.append(contentsOf:
                ranges.map { range in (range, parameter) }
            )
        }        
        return sortedRangesParameters.sorted {
            (rangeParameter0: (range: NSRange, EquationParameter),
            rangeParameter1: (range: NSRange, EquationParameter)) -> Bool in
            rangeParameter0.range.location < rangeParameter1.range.location
        }
    }
    private let parametersRegex = try! NSRegularExpression(
        pattern: Self.parametersRegexString)
    
    
    // MARK: - Initialization
    
    init(equation: String) {
        self.latex = equation
        parseParameters()
        function = try? getValidExpression(fromEquationString: latex)
    }
    
    
    // MARK: - API Methods
    
    mutating func setEquation(_ equation: String) {
        latex = equation
        parseParameters()
        function = try? getValidExpression(fromEquationString: latex)
    }
    
    
    // MARK: - Private Methods
    
    private mutating func parseParameters() {
        let results = parametersRegex.matches(in: latex)
        
        parametersRanges.removeAllExceptIntersect(with: results) {
            $0.parameter.name == $1.group
        }
        for i in (0..<parametersRanges.count) {
            parametersRanges[i].ranges = []
        }
        
        
        results
            .removingAllIntersection(with: parametersRanges) {
                $0.group == $1.parameter.name &&
                    [$0.range] == $1.ranges
            }
            .forEach { match in
                let parameter = EquationParameter(
                    name: match.group, value: Self.defaultParameterValue)
                
                if let index = parametersRanges.firstIndex(where: {
                    $0.parameter.name == parameter.name
                }) {
                    parametersRanges[index].ranges.append(match.range)
                } else {
                    parametersRanges.append((parameter, [match.range]))
                }
            }
    }
    
    private func getValidExpression(
        fromEquationString equationString: String) throws -> String {
        var equationNSString = equationString as NSString
        var sortedRangesParameters = self.sortedRangesParameters
        for i in (0..<sortedRangesParameters.count) {
            let rangeParameter = sortedRangesParameters[i]
            let variableName = rangeParameter.parameter.name
            let value = "\(rangeParameter.parameter.value)"
            let subtitutedValueLengthDifference =
                value.count - variableName.count
            
            let range = rangeParameter.range
            equationNSString = equationNSString.replacingCharacters(in: range, with: value)
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
        
        let equationString = equationNSString as String
        
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
