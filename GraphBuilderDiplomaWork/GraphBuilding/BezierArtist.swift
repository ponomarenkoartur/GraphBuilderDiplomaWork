//
//  BezierArtist.swift
//  EquationRecognition
//
//  Created by artur_ios on 12.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import UIKit


class BezierArtist {
    
    func bezierPath(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        return path
    }
    
    func merge(_ pathes: UIBezierPath...) -> UIBezierPath {
        let compoundPath = UIBezierPath()
        for path in pathes {
            compoundPath.append(path)
        }
        compoundPath.close()
        return compoundPath
    }
}
