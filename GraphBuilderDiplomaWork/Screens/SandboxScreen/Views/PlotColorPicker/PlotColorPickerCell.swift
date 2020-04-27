//
//  PlotColorPickerCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class PlotColorPickerCell: BaseCollectionCell {
    
    
    // MARK: - Properties
    
    var color: UIColor {
        get { imageView.tintColor }
        set { imageView.tintColor = newValue }
    }
    
    // MARK: Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.plotIcon()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(imageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
