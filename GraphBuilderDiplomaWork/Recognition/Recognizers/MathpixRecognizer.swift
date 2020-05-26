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
        image: image, outputFormats: [FormatLatex.simplified]) {
            error, result in
            if let result = result {
                let resultArray = result.toLatexStringArray().map {
                    Equation(equation: $0)
                }
                completion(Result.success(resultArray))
            } else {
                let error = error ?? EquationRecognitionError.noEquationFound
                completion(Result.failure(error))
            }
        }
    }
}


extension MathpixRecognizer {
    var description: String {
        "Mathpix"
    }
}
