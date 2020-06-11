//
//  TopicProccedToPlotBuildingCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SwiftyAttributes
import iosMath


class TopicProccedToPlotBuildingCell: BaseTableViewCell {
    
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didTap: () -> () = {}
    
    // MARK: Views
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.turquoise()
        
        button.setTitle("See plot in sandbox".uppercased())
        button.setTitleColor(Color.inverseText()!, for: .normal)
        button.setTitleColor(Color.defaultText()!, for: .highlighted)
        button.titleLabel?.font = Font.sfProDisplayMedium(size: 15)!
        
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
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().offset(-20)
        }
    }
}
