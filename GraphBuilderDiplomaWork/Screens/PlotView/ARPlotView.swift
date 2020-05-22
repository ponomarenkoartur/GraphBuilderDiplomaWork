//
//  ARPlotView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 15.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import ARKit


class ARPlotView: BaseARSCNView {
    
    
    // MARK: - Properties
    
    var plotScene: PlotScene { scene as! PlotScene }
    
    override var scene: SCNScene {
        didSet {
            if let _ = scene as? PlotScene {
                plotScene.cameraNode = pointOfView!
            }
        }
    }
    
    
    // MARK: - Setup Methods
    
    override func setupScene() {
        super.setupScene()
        rootNode.position = SCNVector3(0, -1, -1)
    }
//
//    override func setupLight() {
//        super.setupLight()
//        let light = SCNLight()
//        light.type = .directional
//
//        let topLightNode = SCNNode()
//        topLightNode.name = "Top light node"
//        topLightNode.light = light
//        topLightNode.position.y = 10
//        topLightNode.eulerAngles.x = -.pi / 2
//
//        let bottomLightNode = SCNNode()
//        bottomLightNode.name = "Bottom light node"
//        bottomLightNode.light = light
//        bottomLightNode.position.y = -10
//        bottomLightNode.eulerAngles.x = .pi / 2
//
//        rootNode.addNodes(topLightNode, bottomLightNode)
//    }

}
