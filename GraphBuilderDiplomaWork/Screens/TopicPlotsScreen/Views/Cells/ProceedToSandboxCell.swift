//
//  ProceedToSandboxCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SwiftyAttributes


class ProceedToSandboxCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didTap: () -> () = {}
    
    // MARK: Views
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.turquoise()
        
        let title = "To sandbox".uppercased()
            .withFont(Font.sfProDisplayMedium(size: 15)!)
            .withTextColor(.white)
        button.setAttributedTitle(title)
        button.setImage(Image.sandbox())
        
        button.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.equalTo(137)
        }
        
        button.rx.tap
            .subscribe(onNext: { _ in self.didTap() })
            .disposed(by: bag)
        
        return button
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(button)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview().offset(-20)
        }
    }
}
