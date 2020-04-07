//
//  MathpixRecognizer.swift
//  EquationRecognition
//
//  Created by artur_ios on 19.11.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import MathpixClient
import UIKit

class MathpixRecognizer: EquationRecognizer {
    func recognize(
        _ image: UIImage,
        completion: @escaping ((Result<[Equation], Error>) -> Void) = { _ in }) {
        MathpixClient.recognize(
        image: image, outputFormats: [FormatLatex.simplified, FormatWolfram.on]) {
            error, result in
            
            let functions: [Any] = [
                { (x: Float) -> Float in pow(x, 2) },
                { (x: Float, y: Float) -> Float in pow(x, 2) + pow(y, 2) },
                { (x: Float, y: Float) -> Float in pow(x, 3) + pow(y, 3) },
                { (x: Float, y: Float) -> Float in sin(10 * (x * x + y * y))/10 },
                { (x: Float, y: Float) -> Float in sin(5 * x) * cos(5 * y) / 5 },
                { (x: Float, y: Float) -> Float in Float(pow(Double(x * x + y * y), 0.5)) }
            ]
            
            completion(Result.success([
                Equation(latex: "x^2", function: functions[0]),
                Equation(latex: "x^2 + y^2", function: functions[1]),
                Equation(latex: "x^3 + y^3", function: functions[2]),
                Equation(latex: "sin(10(x^2+y^2))/10", function: functions[3]),
                Equation(latex: "sin(5x)*cos(5y)/5", function: functions[4]),
                Equation(latex: "(x^2+y^2)^0.5", function: functions[5]),
            ]))
        }
    }
}


extension MathpixRecognizer {
    var description: String {
        return "Mathpix"
    }
}
