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
    
    private var axises: (x: AxisNode, y: AxisNode, z: AxisNode)!
    private var axisesScale = SCNVector3(1, 1, 1)
    
    
    // MARK: - Setup Methods
    
    override func setupChildNodes() {
        super.setupChildNodes()
        let scene = SCNScene(named: "Grid.scn")!
        let node = scene.rootNode
        addChildNode(node)
        
        let axisNodeFabric = AxisNodeFabric()
        if let xNode = node.childNode(withName: "x-axis", recursively: true),
            let yNode = node.childNode(withName: "y-axis", recursively: true),
            let zNode = node.childNode(withName: "z-axis", recursively: true),
            let xAxisNode = axisNodeFabric.create(from: xNode),
            let yAxisNode = axisNodeFabric.create(from: yNode),
            let zAxisNode = axisNodeFabric.create(from: zNode) {
            axises = (xAxisNode, yAxisNode, zAxisNode)
            
            addNodes(xAxisNode, yAxisNode, zAxisNode)
        } else {
            fatalError("Can't initialize axises")
        }
        
//        let xAxisNode = node.childNode(withName: "x-axis", recursively: true)!
//        let yAxisNode = node.childNode(withName: "y-axis", recursively: true)!
//        let zAxisNode = node.childNode(withName: "z-axis", recursively: true)!
//        axises = (xAxisNode, yAxisNode, zAxisNode)
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
    
    func scale(_ scale: SCNVector3, animationDuration: TimeInterval = 0) {
        axises.x.setScale(scale.x, animationDuration: animationDuration)
        axises.y.setScale(scale.y, animationDuration: animationDuration)
        axises.z.setScale(scale.z, animationDuration: animationDuration)
    }
}


// MARK: - GridBoundable

extension PlotGrid: GridBoundable {
    func setBounds(x: ValuesBounds?, y: ValuesBounds?, z: ValuesBounds?) {
        if let x = x {
            axises.x.setBounds(x)
        }
        if let y = y {
            axises.y.setBounds(y)
        }
        if let z = z {
            axises.z.setBounds(z)
        }
    }
}
