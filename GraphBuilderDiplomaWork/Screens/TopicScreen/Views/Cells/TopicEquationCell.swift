//
//  TopicEquationCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 11.06.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SwiftyAttributes
import iosMath


class TopicEquationCell: BaseTableViewCell {
    
    
    
    // MARK: - Properties
    
    // MARK: Views
    
    private lazy var latexLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.textColor = Color.defaultText()!
        label.textAlignment = .center
        label.font = MTFontManager().xitsFont(withSize: 15)
        return label
    }()
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(latexLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        latexLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
//            $0.width.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().offset(-20)
        }
    }
    
    
    // MARK: - API Methods
    
    func setLatex(_ latex: String) {
        latexLabel.latex = latex
    }
}
