//
//  FakeRecognizer.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 12.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class FakeRecognizer: EquationRecognizer {
    func recognize(_ image: UIImage, completion: @escaping ((Result<[Equation], Error>) -> Void)) {
        let equations = [
            Equation(equation: "x^2"),
            Equation(equation: "sqrt(x^2-x^4)"),
            Equation(equation: "x^2 + y^2"),
            Equation(equation: "x^3 + y^3"),
            Equation(equation: "sin(10(x^2+y^2))/10"),
            Equation(equation: "sin(5x)*cos(5y)/5"),
            Equation(equation: "(x^2+y^2)^0.5"),
            Equation(equation: "sin(cos(x))*sin(cos(y))"),
            Equation(equation: "sin(sin(sin(x)))*sin(sin(sin(y)))"),
        ]
        completion(Result.success(equations))
    }
}
