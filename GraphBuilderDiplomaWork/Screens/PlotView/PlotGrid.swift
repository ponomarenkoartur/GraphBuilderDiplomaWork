//
//  PlotGrid.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


protocol PlotGridProtocol: GridBoundable {
    func scale(_ scale: SCNVector3, animationDuration: TimeInterval)
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
    
            axises.y.position.x = -Float(x.mid)
            axises.z.position.x = -Float(x.mid)
        }
        if let y = y {
            axises.y.setBounds(y)
    
            axises.x.position.y = -Float(y.mid)
            axises.z.position.y = -Float(y.mid)
        }
        if let z = z {
            axises.z.setBounds(z)
    
            axises.x.position.z = -Float(z.mid)
            axises.y.position.z = -Float(z.mid)
        }
    }
}
