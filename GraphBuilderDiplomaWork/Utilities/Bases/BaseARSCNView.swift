//
//  BaseARSCNView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 15.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//


import ARKit
import RxSwift


class BaseARSCNView: ARSCNView {
    

    // MARK: - Properties
    
    let bag = DisposeBag()
    var rootNode: SCNNode { scene.rootNode }
    

    // MARK: - Initialization
    
    init(scene: SCNScene = SCNScene(), frame: CGRect = .zero) {
        super.init(frame: frame, options: nil)
        self.scene = scene
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scene = SCNScene()
        commonInit()
    }
    
    private func commonInit() {
        setupDelegates()
        setupScene()
        setupLight()
        setupUI()
        setupBinding()
        setupGesturesRecognizers()
    }
    
    
    // MARK: - Setup Methods
    
    /// Call 'addSubview' methods before caliing super.setupUI()
    /// in overrided methods
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func setupScene() {}
    
    func setupLight() {}
    
    func setupDelegates() {}
    
    func addSubviews() {}
    
    func setupConstraints() {}
    
    func setupBinding() {}
    
    func setupGesturesRecognizers() {}
}

