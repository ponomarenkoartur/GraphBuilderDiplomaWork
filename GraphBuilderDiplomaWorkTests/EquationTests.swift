//
//  EquationTests.swift
//  GraphBuilderDiplomaWorkTests
//
//  Created by Artur on 07.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import XCTest


class EquationTests: XCTestCase {
    
    func testParameterParsing() {
        func getParametersNames(from equation: Equation) -> Set<String> {
            Set(equation.parameters.map { $0.name })
        }
        
        let equation0 = Equation(equation: "sin(a*x)+sqrt(y)+b/c")
        let equation1 = Equation(equation: "sin(x)+sqrt(y)")
        
        XCTAssertTrue(getParametersNames(from: equation0) == ["a", "b", "c"])
        XCTAssertTrue(getParametersNames(from: equation1) == [])
    }
}
