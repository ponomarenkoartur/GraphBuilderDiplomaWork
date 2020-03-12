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
        let functions: [Any] = [
        { (x: Float) -> Float in pow(x, 2) },
        { (x: Float) -> Float in sqrt(pow(x, 2)-pow(x, 4)) },
        { (x: Float, y: Float) -> Float in pow(x, 2) + pow(y, 2) },
        { (x: Float, y: Float) -> Float in pow(x, 3) + pow(y, 3) },
        { (x: Float, y: Float) -> Float in sin(10 * (x * x + y * y))/10 },
        { (x: Float, y: Float) -> Float in sin(5 * x) * cos(5 * y) / 5 },
        { (x: Float, y: Float) -> Float in Float(pow(Double(x * x + y * y), 0.5)) }
        ]
        
        completion(Result.success([
            Equation(latex: "x^2", function: functions[0]),
            Equation(latex: "sqrt(x^2-x^4)", function: functions[1]),
            Equation(latex: "x^2 + y^2", function: functions[2]),
            Equation(latex: "x^3 + y^3", function: functions[3]),
            Equation(latex: "sin(10(x^2+y^2))/10", function: functions[4]),
            Equation(latex: "sin(5x)*cos(5y)/5", function: functions[5]),
            Equation(latex: "(x^2+y^2)^0.5", function: functions[6]),
        ]))
    }
    
    
}
