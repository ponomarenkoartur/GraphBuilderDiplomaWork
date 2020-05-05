//
//  SCNNode extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 29.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit

extension SCNNode {
    func addNodes(_ nodes: SCNNode...) {
        nodes.forEach { addChildNode($0) }
    }
}
