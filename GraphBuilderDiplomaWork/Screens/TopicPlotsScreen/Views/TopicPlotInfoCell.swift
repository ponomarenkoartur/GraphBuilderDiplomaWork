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
    
    // MARK: Callbacks
    
    var didTapPreviousPlotButton: () -> () = {}
    var didTapNextPlotButton: () -> () = {}
    
    // MARK: Views
    
    private lazy var blurView: UIView = {
        let visualEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView.init(effect: visualEffect)
        return view
    }()
    
    private(set) lazy var previousPlotButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.prevPlot())
        button.imageView?.contentMode = .center
        button.snp.makeConstraints {
            $0.width.equalTo(42)
            $0.height.equalTo(77)
        }
        button.rx.tap
            .subscribe(onNext: { _ in self.didTapPreviousPlotButton() })
            .disposed(by: bag)
        return button
    }()
    
    private(set) lazy var nextPlotButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.nextPlot())
        button.imageView?.contentMode = .center
        button.snp.makeConstraints {
            $0.width.equalTo(42)
            $0.height.equalTo(77)
        }
        button.rx.tap
            .subscribe(onNext: { _ in self.didTapNextPlotButton() })
            .disposed(by: bag)
        return button
    }()
    
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.round([.topLeft, .topRight], radius: 5)
    }
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubviews([
            blurView, previousPlotButton, nextPlotButton
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        previousPlotButton.snp.makeConstraints { $0.top.left.equalToSuperview() }
        nextPlotButton.snp.makeConstraints { $0.top.right.equalToSuperview() }
    }
}
