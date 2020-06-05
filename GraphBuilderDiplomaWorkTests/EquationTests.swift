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
        let equation2 = Equation(equation: "sin(a*x)+sqrt(y)+a/a")
        var equation3 = Equation(equation: "sin(x)+cos(z)+a")
        let equation4 = Equation(equation: "")
        equation3.parameters.filter { $0.name == "a" }.forEach { $0.value = 2 }
        equation3.setEquation("sin(x)+cos(z)+a+")
        
        XCTAssertEqual(getParametersNames(from: equation0), ["a", "b", "c"])
        XCTAssertEqual(getParametersNames(from: equation1), [])
        XCTAssertEqual(getParametersNames(from: equation2), ["a"])
        XCTAssertEqual(getParametersNames(from: equation3), ["a"])
        XCTAssertEqual(getParametersNames(from: equation4), [])
    }
    
    func testParametersSubtitution() {
        Equation.defaultParameterValue = 1
        
        let equation0 = Equation(equation: "sin(a*x)+sqrt(y)+b/c")
        let equation1 = Equation(equation: "sin(x)+sqrt(y)")
        let equation2 = Equation(equation: "sin(a*x)+sqrt(y)+b/c + a")
        equation2.parameters.filter { $0.name == "a" }.forEach { $0.value = 2 }
        let equation3 = Equation(equation: "sin(x)+cos(z)+a+a")
        var equation4 = Equation(equation: "sin(x)+cos(z)+a")
        equation4.setEquation("sin(x)+cos(z)+a+a")
        var equation5 = Equation(equation: "sin(x)+cos(z)+a+a+a")
        equation5.setEquation("sin(x)+cos(z)+a+a")
        var equation6 = Equation(equation: "sin(x)+cos(z)+a")
        equation6.parameters.filter { $0.name == "a" }.forEach { $0.value = 2 }
        equation6.setEquation("sin(x)+cos(z)+a+")
        
        XCTAssertEqual(equation0.function, "sin(1.0*x)+sqrt(y)+1.0/1.0")
        XCTAssertEqual(equation1.function, "sin(x)+sqrt(y)")
        XCTAssertEqual(equation2.function, "sin(2.0*x)+sqrt(y)+1.0/1.0 + 2.0")
        XCTAssertEqual(equation3.function, "sin(x)+cos(z)+1.0+1.0")
        XCTAssertEqual(equation4.function, "sin(x)+cos(z)+1.0+1.0")
        XCTAssertEqual(equation5.function, "sin(x)+cos(z)+1.0+1.0")
        XCTAssertEqual(equation6.function, "sin(x)+cos(z)+2.0+")
    }
}
