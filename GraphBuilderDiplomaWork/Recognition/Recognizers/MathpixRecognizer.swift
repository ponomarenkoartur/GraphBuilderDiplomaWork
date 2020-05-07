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
            completion(Result.success([]))
        }
    }
}


extension MathpixRecognizer {
    var description: String {
        "Mathpix"
    }
}
