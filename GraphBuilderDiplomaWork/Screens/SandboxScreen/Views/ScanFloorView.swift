//
//  ScanFloorView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class ScanFloorView: BaseView {
    
    
    // MARK: - Properties
    
    var scanProgress: Int = 0
    
    
    // MARK: Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.animationImages = (0...193).map {
            UIImage(named: "icon_\($0)")!
        }
        imageView.contentMode = .scaleAspectFill
        imageView.startAnimating()
        return imageView
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = "Scan floor to place the plot"
            .withFont(Font.sfProDisplayMedium(size: 20)!)
            .withTextColor(.white)
        return label
    }()
    
    private lazy var scanProgressLabel: UILabel = {
        let label = UILabel()
        label.font = Font.sfProDisplayRegular(size: 18)!
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Scan progress: 0%"
        label.textAlignment = .center
        return label
    }()
    
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(imageView, instructionLabel, scanProgressLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints {
            $0.width.equalTo(134)
            $0.height.equalTo(120)
            $0.center.equalToSuperview()
        }
        instructionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-60)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }
        scanProgressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-60)
            $0.top.equalTo(instructionLabel.snp.bottom).offset(20)
        }
        
    }
    
    // MARK: - API Methods
    
    func setProgress(_ value: Int) {
        self.scanProgress = value
        scanProgressLabel.text = "Scan progress: \(value)%"
    }
}
