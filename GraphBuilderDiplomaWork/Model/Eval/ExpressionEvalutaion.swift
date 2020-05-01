//
//  ExpressionEvalutaion.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation

enum EvalError: String, Error {
    case unableToParse = "Unable to parse the format string"
    case unableToEvaluate = "Unable to evaluate the format string"
}

func eval(_ equation: String) throws -> Double? {
    var exception: NSException? = nil
    let result = Eval.eval(equation, with: &exception)
    
    guard let e = exception else { return result.doubleValue }
    
    switch e.reason {
    case let reason
        where reason?.contains(EvalError.unableToParse.rawValue) ?? false:
        throw EvalError.unableToParse
    default:
        throw EvalError.unableToEvaluate
    }
}
