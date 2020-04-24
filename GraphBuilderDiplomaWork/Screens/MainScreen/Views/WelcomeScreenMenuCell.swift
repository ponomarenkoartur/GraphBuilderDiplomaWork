//
//  WelcomeScreenMenuCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class WelcomeScreenMenuCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    var labelTextColor: UIColor? = .black {
        didSet {
            titleLabel.textColor = labelTextColor
        }
    }
    
    var labelText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue?.uppercased() }
    }
    
    // MARK: Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.leftArrowWelcomeMenu()
        imageView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(14)
        }
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.sfProDisplayRegular(size: 22)
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(stackView)
            stackView.addArrangedSubviews([
                arrowImageView, titleLabel
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().offset(-51)
        }
    }
}
