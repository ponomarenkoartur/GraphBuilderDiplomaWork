//
//  BaseSCNScene.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit


class BaseSCNScene: SCNScene {
    
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupNodes()
    }
    
    func setupNodes() {}
}
