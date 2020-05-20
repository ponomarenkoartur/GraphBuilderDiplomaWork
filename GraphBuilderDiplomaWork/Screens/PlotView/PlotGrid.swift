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
        
        
        axises.y.position.x = -Float(axises.x.valuesBounds.mid * defaultBoxSize / axises.x.valuesBounds.delta) * scale.x
        axises.z.position.x = -Float(axises.x.valuesBounds.mid * defaultBoxSize / axises.x.valuesBounds.delta) * scale.x

        axises.x.position.y = -Float(axises.y.valuesBounds.mid * defaultBoxSize / axises.y.valuesBounds.delta) * scale.y
        axises.z.position.y = -Float(axises.y.valuesBounds.mid * defaultBoxSize / axises.y.valuesBounds.delta) * scale.y

        axises.x.position.z = -Float(axises.z.valuesBounds.mid * defaultBoxSize / axises.z.valuesBounds.delta) * scale.z
        axises.y.position.z = -Float(axises.z.valuesBounds.mid * defaultBoxSize / axises.z.valuesBounds.delta) * scale.z
    }
}


// MARK: - GridBoundable

extension PlotGrid: GridBoundable {
    func setBounds(x: ValuesBounds?, y: ValuesBounds?, z: ValuesBounds?) {
        if let x = x {
            axises.x.setBounds(x)
    
            axises.y.position.x = -Float(x.mid * defaultBoxSize / x.delta) * axises.x.axisScale
            axises.z.position.x = -Float(x.mid * defaultBoxSize / x.delta) * axises.x.axisScale
        }
        if let y = y {
            axises.y.setBounds(y)
    
            axises.x.position.y = -Float(y.mid * defaultBoxSize / y.delta) * axises.y.axisScale
            axises.z.position.y = -Float(y.mid * defaultBoxSize / y.delta) * axises.y.axisScale
        }
        if let z = z {
            axises.z.setBounds(z)
    
            axises.x.position.z = -Float(z.mid * defaultBoxSize / z.delta) * axises.z.axisScale
            axises.y.position.z = -Float(z.mid * defaultBoxSize / z.delta) * axises.z.axisScale
        }
    }
}
