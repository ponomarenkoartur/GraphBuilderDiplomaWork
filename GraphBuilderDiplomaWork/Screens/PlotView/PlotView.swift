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
        autoenablesDefaultLighting = true
    }
    
}
