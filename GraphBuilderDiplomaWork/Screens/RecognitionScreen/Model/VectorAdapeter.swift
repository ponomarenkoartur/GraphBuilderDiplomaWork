//
//  VectorAdapeter.swift
//  EquationRecognition
//
//  Created by artur_ios on 12.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import UIKit


class VectorAdapter {
    
        
    // MARK: - Other Methods
    
    func convert(_ vector: Vector2) -> CGPoint {
        CGPoint(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
}
