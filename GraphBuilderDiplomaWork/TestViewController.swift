//
//  TestViewController.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import RxKeyboard


class TestViewController: BaseVC {
    
    
    private lazy var keyboard = SandboxKeyboard()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.inputView = keyboard
        return textField
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        shouldPresentNavigationBar = false
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([textField])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.66)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        RxKeyboard.instance.visibleHeight.drive(onNext: { print($0) })
            .disposed(by: bag)
    }
}
