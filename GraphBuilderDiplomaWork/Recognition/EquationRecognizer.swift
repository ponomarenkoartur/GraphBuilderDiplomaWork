//
//  EquationRecognizer.swift
//  EquationRecognition
//
//  Created by artur_ios on 19.11.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import UIKit


protocol EquationRecognizer {
    func recognize(
        _ image: UIImage,
        completion: @escaping ((_ result: Result<[Equation], Error>) -> Void))
}

enum EquationRecognitionError: String, Error {
    case noEquationFound
}



extension CustomStringConvertible where Self: EquationRecognizer {
    var description: String { String(describing: Self.self) }
}
