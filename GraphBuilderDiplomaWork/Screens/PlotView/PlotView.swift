//
//  PlotView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 29.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


class PlotView: BaseSCNView {
    
    
    // MARK: - Properties
    
    var plotScene: PlotScene { scene as! PlotScene }
    
    
    // MARK: - Setup Methods
    
    override func setupScene() {
        super.setupScene()
        backgroundColor = Color.grayBackground()
        debugOptions = [.renderAsWireframe]
    }
    
    override func setupLight() {
        super.setupLight()
        let light = SCNLight()
        light.type = .directional
        
        let topLightNode = SCNNode()
        topLightNode.name = "Top light node"
        topLightNode.light = light
        topLightNode.position.y = 10
        topLightNode.eulerAngles.x = -.pi / 2
        
        let bottomLightNode = SCNNode()
        bottomLightNode.name = "Bottom light node"
        bottomLightNode.light = light
        bottomLightNode.position.y = -10
        bottomLightNode.eulerAngles.x = .pi / 2
        
        rootNode.addNodes(topLightNode, bottomLightNode)
    }
    
    
}
