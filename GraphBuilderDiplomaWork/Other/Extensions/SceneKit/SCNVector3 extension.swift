//
//  SCNVector3 extension.swift
//  FurnitureMeasureSample
//
//  Created by artur_ios on 2/19/19.
//  Copyright © 2019 artur_ios. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    init(matrix: simd_float4x4) {
        self.init(matrix.columns.3.x,
                  matrix.columns.3.y,
                  matrix.columns.3.z)
    }
    
    init(_ value: Float) {
        self.init(value, value, value)
    }
    
    func distanceWithoutY(to receiver: SCNVector3) -> Float {
        let xd = receiver.x - x
        let zd = receiver.z - z
        let distance = Float(sqrt(xd * xd + zd * zd))
        return abs(distance)
    }
}


func *(left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3(left.x * right,
                      left.y * right,
                      left.z * right)
}

func /(vector: SCNVector3, number: Float) -> SCNVector3 {
    SCNVector3(vector.x / number,
               vector.y / number,
               vector.z / number)
}

func /(number: Float, vector: SCNVector3) -> SCNVector3 {
    SCNVector3(number / vector.x,
                      number / vector.y,
                      number / vector.z)
}

func /(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    SCNVector3(left.x / right.x,
               left.y / right.y,
               left.z / right.z)
}


func *=(left: inout SCNVector3, right: Float) {
    left = SCNVector3(left.x * right,
                      left.y * right,
                      left.z * right)
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    SCNVector3(left.x + right.x,
               left.y + right.y,
               left.z + right.z)
}

func +=(left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    SCNVector3(left.x - right.x,
               left.y - right.y,
               left.z - right.z)
}

func -=(left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}
