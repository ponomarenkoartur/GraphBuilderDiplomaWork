//
//  ExpressionEvalutaion.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


func eval(_ equation: String) -> Double? {
    var exceptionPointer: NSException? = nil
    let result = Eval.eval(equation, with: &exceptionPointer)
    return exceptionPointer == nil ? result.doubleValue : nil
}
