//
//  SandboxAddPlotCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 05.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxAddPlotCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    // MARK: Callbacks
    
    var didTap: () -> () = {}
    
    // MARK: Views
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.plusButton())
        button.imageView?.contentMode = .center
        button.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(50)
        }
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        setupGestures()
        backgroundColor = .clear
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(plusButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        plusButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
    }
    
    private func setupGestures() {
        contentView.rx.tapGesture().subscribe(onNext: { _ in self.didTap() })
            .disposed(by: bag)
    }
}
