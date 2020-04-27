//
//  BaseButton.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxSwift


class BaseButton: UIButton {
    
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupBinding()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUIAfterLayoutSubviews()
    }
        
    
    /// Call 'addSubview' methods before caliing super.setupUI()
    /// in overrided methods
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func setupUIAfterLayoutSubviews() {}
    
    func addSubviews() {}
    
    func setupConstraints() {}
    
    func setupBinding() {}
}

