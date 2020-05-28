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
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var latexLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = MTFontManager().xitsFont(withSize: 15)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.turquoise()
        
        let title = "See plot in sandbox".uppercased()
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
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubviews(latexLabel, button)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        verticalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().offset(-20)
        }
        button.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    
    // MARK: - API Methods
    
    func setLatex(_ latex: String) {
        latexLabel.latex = latex
    }
}
