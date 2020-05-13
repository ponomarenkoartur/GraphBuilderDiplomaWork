//
//  BaseSCNView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 29.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit
import RxSwift


class BaseSCNView: SCNView {
    

    // MARK: - Properties
    
    let bag = DisposeBag()
    var rootNode: SCNNode { scene!.rootNode }
    

    // MARK: - Initialization
    
    convenience init(scene: PlotScene = PlotScene(), frame: CGRect = .zero) {
        self.init(frame: frame, options: nil)
        self.scene = scene
    }
    
    override init(frame: CGRect = .zero, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        self.scene = PlotScene()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scene = PlotScene()
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupScene()
        setupLight()
        setupGestures()
    }
    
    
    // MARK: - Setup Methods
    
    func setupScene() {}
    
    func setupLight() {}
    
    func setupGestures() {}
    
    
    /// Call 'addSubview' methods before caliing super.setupUI()
    /// in overrided methods
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {}
    
    func setupConstraints() {}
}

