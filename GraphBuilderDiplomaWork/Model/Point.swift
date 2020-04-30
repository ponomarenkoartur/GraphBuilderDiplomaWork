//
//  Point.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit

protocol Point {
    var x: Float { get }
    var y: Float { get }
    var z: Float { get }
    
    var vector3: Vector3 { get }
}

typealias Vector3 = SCNVector3

extension SCNVector3: Point {
    var vector3: Vector3 { return self }
}

struct Vector2: Point {
    var x: Float
    var y: Float
    let z: Float = 0
    
    var vector3: Vector3 {
        return Vector3(x, y, z)
    }
}
