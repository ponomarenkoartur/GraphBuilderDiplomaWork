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
        
        XCTAssertEqual(getParametersNames(from: equation0), ["a", "b", "c"])
        XCTAssertEqual(getParametersNames(from: equation1), [])
    }
    
    func testParametersSubtitution() {
        Equation.defaultParameterValue = 1
        
        let equation0 = Equation(equation: "sin(a*x)+sqrt(y)+b/c")
        let equation1 = Equation(equation: "sin(x)+sqrt(y)")
        let equation2 = Equation(equation: "sin(a*x)+sqrt(y)+b/c + a")
        equation2.parameters.filter { $0.name == "a" }.forEach { $0.value = 2 }
        
        XCTAssertEqual(equation0.function, "sin(1.0*x)+sqrt(y)+1.0/1.0")
        XCTAssertEqual(equation1.function, "sin(x)+sqrt(y)")
        XCTAssertEqual(equation2.function, "sin(2.0*x)+sqrt(y)+1.0/1.0 + 2.0")
    }
}
