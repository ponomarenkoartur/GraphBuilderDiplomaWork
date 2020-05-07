//
//  Equation.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 12.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation

struct Equation {
    
    
    // MARK: - Constants
    
    private static let parametersRegexString = "(?<=^|\\W)[a-z&&[^xyz]](?=$|\\W)"
    
    
    // MARK: - Properties
    
    private(set) var latex: String
    private(set) var function: Any? = nil
    var parameters: [PlotEquationParameter] {
        parametersRanges.map { $0.parameter }
    }
    private var parametersRanges:
        [(parameter: PlotEquationParameter, range: NSRange)] = []
    private let parametersRegex = try! NSRegularExpression(
        pattern: Self.parametersRegexString)
    
    
    // MARK: - Initialization
    
    init(latex: String, function: Any? = nil) {
        self.latex = latex
        self.function = function
        parseParameters()
    }
    
    init(equation: String) {
        self.init(latex: equation, function: equation)
    }
    
    
    // MARK: - API Methods
    
    mutating func setEquation(_ equation: String) {
        latex = equation
        function = equation
        parseParameters()
    }
    
    
    // MARK: - Private Methods
    
    private mutating func parseParameters() {
        let results = parametersRegex
            .matches(in: latex)
            .removingDuplicates { $0.group == $1.group }
        parametersRanges.removeAllExceptIntersect(with: results) {
            $0.parameter.name == $1.group
        }
        
        results
            .removingAllIntersection(with: parameters) { $0.group == $1.name }
            .forEach {
                let parameter = PlotEquationParameter(name: $0.group, value: 1)
                parametersRanges.append((parameter, $0.range))
            }
    }
}
