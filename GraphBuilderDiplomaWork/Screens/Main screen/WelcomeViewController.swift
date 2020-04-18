//
//  WelcomeViewController.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import AttributedString


class WelcomeVC: BaseVC {
    
    
    // MARK: - Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { $0.height.equalTo(111) }
        imageView.contentMode = .scaleAspectFit
        imageView.image = Image.arGraphLogo()
        return imageView
    }()
    
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubviews([
            imageView
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(174)
            imageView.snp.makeConstraints { $0.width.equalToSuperview() }
        }
    }
    
}
