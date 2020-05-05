//
//  SCNScene extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


extension SCNScene {
    func addNodes(_ nodes: SCNNode...) {
        nodes.forEach { rootNode.addNodes($0) }
    }
}
