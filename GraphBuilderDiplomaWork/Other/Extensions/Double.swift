//
//  Double.swift
//  EquationRecognition
//
//  Created by artur_ios on 06.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import Foundation

extension Double {
    var isInteger: Bool {
        return floor(self) == self
    }
}
