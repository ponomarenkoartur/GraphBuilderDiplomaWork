//
//  TestViewController.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TestViewController: BaseVC {
    
    
    private lazy var keyboard = SandboxKeyboard()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(keyboard)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        keyboard.snp.makeConstraints {
            $0.center.width.equalToSuperview()
            $0.height.equalTo(236)
        }
    }
}
