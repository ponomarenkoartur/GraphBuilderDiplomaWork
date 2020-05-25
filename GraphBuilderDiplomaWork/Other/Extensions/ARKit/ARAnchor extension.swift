//
//  ARAnchor extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import ARKit

extension ARAnchor {
    var isPlane: Bool { (self as? ARPlaneAnchor) != nil }
}
