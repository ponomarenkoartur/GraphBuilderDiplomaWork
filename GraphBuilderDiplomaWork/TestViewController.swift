//
//  TestViewController.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TestViewController: BaseVC {
    
    
    private lazy var switchControl = NamedSwitchControl()
    
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(switchControl)
        switchControl.leftText = "ABC"
        switchControl.rightText = "DEF"
        switchControl.setPosition(.left)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        switchControl.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
