//
//  AxisNode.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


class AxisNode: SCNNode {
    
    
    // MARK: - Properties
    
    // MARK: Nodes
    
    let cylinder: SCNNode
    let coneArrow: SCNNode
    
    private var cylinderGeometry: SCNCylinder {
        cylinder.geometry as! SCNCylinder
    }
    private var coneGeometry: SCNCone {
        coneArrow.geometry as! SCNCone
    }
    
    
    // MARK: - Initialization
    
    fileprivate init(cylinder: SCNNode, coneArrow: SCNNode) {
        self.cylinder = cylinder
        self.coneArrow = coneArrow
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - API Methods
    
    func setScale(_ scale: Float, animationDuration: TimeInterval = 0) {
        cylinder.scale.y = scale
        coneArrow.position.x = Float(cylinderGeometry.height) * cylinder.scale.y / 2
    }
    
}


class AxisNodeFabric {
    
    
    // MARK: - API Methods
    
    func create(from node: SCNNode) -> AxisNode? {
        guard
            let cylinder = node.childNode(withName: "cylinder",
                                              recursively: true),
            let cone = node.childNode(withName: "cone",
                                          recursively: true),
            let _ = cylinder.geometry as? SCNCylinder,
            let _ = cone.geometry as? SCNCone else {
                return nil
        }
        
        let axisNode = AxisNode(cylinder: cylinder, coneArrow: cone)
        axisNode.addChildNode(node)
        
        return axisNode
    }
    
}
