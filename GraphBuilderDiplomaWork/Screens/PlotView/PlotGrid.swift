//
//  PlotGrid.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


class PlotGrid: BaseSCNNode {
    
    
    // MARK: - Setup Methods
    
    override func setupChildNodes() {
        super.setupChildNodes()
        let scene = SCNScene(named: "Grid.scn")!
        let node = scene.rootNode
        addChildNode(node)
    }
}
