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
        autoenablesDefaultLighting = true
    }

}
