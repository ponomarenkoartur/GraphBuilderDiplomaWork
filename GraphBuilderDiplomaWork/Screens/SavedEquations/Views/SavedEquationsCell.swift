//
//  SavedEquationsCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import iosMath


class SavedEquationsCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = Font.sfProDisplayRegular(size: 15)
        label.textColor = Color.turquoise()
        label.snp.makeConstraints { $0.width.equalTo(17) }
        return label
    }()
    
    private lazy var latexLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.font = MTFontManager().xitsFont(withSize: 15)
        label.textColor = Color.defaultText()!
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = Color.grayBackground()
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(horizontalStackView)
        horizontalStackView.addArrangedSubviews([
            numberLabel,
            UIView.createSpacer(w: 3),
            latexLabel,
            UIView()
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        contentView.snp.makeConstraints { $0.height.equalTo(49) }
        horizontalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-30)
        }
    }
    
    
    // MARK: - API Methods
    
    func setNumber(_ number: Int) {
        numberLabel.text = String(number)
    }
    
    func setLatexText(_ text: String) {
        latexLabel.latex = text
    }
}
