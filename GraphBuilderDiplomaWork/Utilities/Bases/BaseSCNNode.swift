//
//  BaseSCNNode.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit
import RxSwift


class BaseSCNNode: SCNNode {
    
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    
    
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
        setupChildNodes()
        setupBinding()
    }
    
    // MARK: - Setup Methods
    
    func setupChildNodes() {}
    
    func setupBinding() {}
}
