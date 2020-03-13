//
//  EquationTransformator.swift
//  EquationRecognition
//
//  Created by artur_ios on 06.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//


import SceneKit


class EquationTransformator {
    
    
    func getGraph(from equation: Equation) -> Graph? {
        if let function = equation.function as? Function2D {
            return Graph(points: getPoints(function))
        } else if let function = equation.function as? Function3D {
            return Graph(points: getPoints(function))
        } else {
            return nil
        }
    }
    
    
    private func getPoints(_ f: (_ x: Float) -> Float) -> [Point] {
        stride(from: -1, to: 1, by: 0.1).map {
            let x = Float($0)
            return Vector2(x: x, y: f(x))
        }
    }
    
    private func getPoints(_ f: (_ x: Float, _ z: Float) -> Float) -> [Point] {
        var points: [Point] = []
        
        for x in stride(from: -10, to: 10, by: 0.25) {
            for z in stride(from: -10, to: 10, by: 0.25) {
                let x = Float(x)
                let z = Float(z)
                let vector = Vector3(x: x, y: f(x, z), z: z)
//                print(vector)
                points.append(vector)
            }
        }
        
        return points
    }
}
