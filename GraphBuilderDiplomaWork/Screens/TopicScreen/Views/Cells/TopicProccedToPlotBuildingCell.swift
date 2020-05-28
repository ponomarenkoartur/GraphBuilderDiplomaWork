//
//  TopicProccedToPlotBuildingCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SwiftyAttributes


class TopicProccedToPlotBuildingCell: BaseTableViewCell {
    
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didTap: () -> () = {}
    
    // MARK: Views
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.turquoise()
        
        let title = "To graph building".uppercased()
            .withFont(Font.sfProDisplayMedium(size: 15)!)
            .withTextColor(Color.inverseText()!)
        button.setAttributedTitle(title)
        
        button.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        button.rx.tap
            .subscribe(onNext: { _ in self.didTap() })
            .disposed(by: bag)
        
        return button
    }()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(button)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview().offset(-10)
            $0.width.equalToSuperview().offset(-20)
        }
    }
}
