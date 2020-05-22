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
    
    private(set) var axises: (x: AxisNode, y: AxisNode, z: AxisNode)!
    
    
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
    }
    
    
    // MARK: - API Methods
    
    func scale(_ scale: SCNVector3, animationDuration: TimeInterval = 0) {
        axises.x.setScale(scale.x, animationDuration: animationDuration)
        axises.y.setScale(scale.y, animationDuration: animationDuration)
        axises.z.setScale(scale.z, animationDuration: animationDuration)
        updateAxisesPosition()
    }
    
    func setTextNodesConstraints(_ constraints: [SCNConstraint]) {
        axises.x.setTextNodesConstraints(constraints)
//        axises.y.setTextNodesConstraints(constraints)
        axises.z.setTextNodesConstraints(constraints)
    }
    
    // MARK: - Private Methods
    
    private func updateAxisesPosition() {
        let minOffset = SCNVector3(
            -Float(defaultBoxSize / 2) * axises.x.axisScale,
            -Float(defaultBoxSize / 2) * axises.y.axisScale,
            -Float(defaultBoxSize / 2) * axises.z.axisScale)
        let maxOffset = SCNVector3(
            Float(defaultBoxSize / 2) * axises.x.axisScale,
            Float(defaultBoxSize / 2) * axises.y.axisScale,
            Float(defaultBoxSize / 2) * axises.z.axisScale)
        
        let target = SCNVector3(
            -Float(axises.x.valuesBounds.mid * defaultBoxSize /
                axises.x.valuesBounds.delta) * axises.x.axisScale,
            -Float(axises.y.valuesBounds.mid * defaultBoxSize /
                axises.y.valuesBounds.delta) * axises.y.axisScale,
            -Float(axises.z.valuesBounds.mid * defaultBoxSize /
                axises.z.valuesBounds.delta) * axises.y.axisScale)
        
        
        axises.y.position.x = min(maxOffset.x, max(minOffset.x, target.x))
        axises.z.position.x = min(maxOffset.x, max(minOffset.x, target.x))
    
        axises.x.position.y = min(maxOffset.y, max(minOffset.y, target.y))
        axises.z.position.y = min(maxOffset.y, max(minOffset.y, target.y))
        
        axises.x.position.z = min(maxOffset.z, max(minOffset.z, target.z))
        axises.y.position.z = min(maxOffset.z, max(minOffset.z, target.z))
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
        updateAxisesPosition()
    }
}
