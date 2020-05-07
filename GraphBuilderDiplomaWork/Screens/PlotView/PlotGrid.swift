//
//  PlotGrid.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


protocol PlotGridProtocol {
    func setOriginOffset(_ vector: SCNVector3)
}

class PlotGrid: BaseSCNNode, PlotGridProtocol {
    
    
    // MARK: - Properties
    
    private var axises: (x: SCNNode, y: SCNNode, z: SCNNode)!
    
    
    // MARK: - Setup Methods
    
    override func setupChildNodes() {
        super.setupChildNodes()
        let scene = SCNScene(named: "Grid.scn")!
        let node = scene.rootNode
        addChildNode(node)
        
        let xAxis = node.childNode(withName: "x-axis", recursively: true)!
        let yAxis = node.childNode(withName: "y-axis", recursively: true)!
        let zAxis = node.childNode(withName: "z-axis", recursively: true)!
        axises = (xAxis, yAxis, zAxis)
    }
    
    
    // MARK: - API Methods
    
    func setOriginOffset(_ vector: SCNVector3) {
        axises.x.position.z = vector.z
        axises.y.position.z = vector.z
        
        axises.x.position.y = vector.y
        axises.z.position.y = vector.y
        
        axises.y.position.x = vector.x
        axises.z.position.x = vector.x
    }
}
