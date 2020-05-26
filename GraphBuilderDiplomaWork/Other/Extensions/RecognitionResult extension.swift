//
//  RecognitionResult extension.swift
//  EquationRecognition
//
//  Created by artur_ios on 19.11.2019.
//  Copyright © 2019 Artur. All rights reserved.
//


import MathpixClient

extension RecognitionResult {
    func toLatexString() -> String? {
        self.parsed?["latex"] as? String
    }
    
    func toLatexStringArray() -> [String] {
        self.parsed?["latex_list"] as? [String] ?? []
    }
}
