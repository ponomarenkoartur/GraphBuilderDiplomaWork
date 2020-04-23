//
//  TopicPlotParameterHeaderView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TopicPlotParameterHeaderView: BaseView {
    
    
    // MARK: - Properties
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Parameters"
        label.textColor = Color.defaultText()
        label.font = Font.sfProDisplayRegular(size: 15)
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(headerLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        headerLabel.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.centerY.equalToSuperview()
        }
    }
    
}
