//
//  TopicPlotInfoCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TopicPlotInfoCell: BaseCollectionCell {
    
    
    // MARK: - Properties
    
    // MARK: Views
    
    private lazy var backgroundRoundedView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = .red
        contentView.round([.topLeft, .topRight], radius: 5)
    }
    
    
}
