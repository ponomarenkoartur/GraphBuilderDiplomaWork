//
//  TopicCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TopicCell: BaseTableViewCell {
    
    
    // MARK: - Constants
    
    private let imagePlaceholder = Image.topicPlaceholder()
    
    
    // MARK: - Properties
    
    var topicTitle: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var detailsText: String? {
        get {
            detailsLabel.text
        }
        set {
            detailsLabel.text = newValue
        }
    }
    
    var topicImage: UIImage? {
        get {
            topicImageView.image == imagePlaceholder ?
                nil : topicImageView.image
        }
        set {
            topicImageView.image = newValue ?? imagePlaceholder
        }
    }
    
    
    // MARK: Views
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var topicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = imagePlaceholder
        imageView.snp.makeConstraints { $0.size.equalTo(48) }
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.sfProDisplaySemibold(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = Font.sfProDisplayRegular(size: 13)
        label.textAlignment = .justified
        label.textColor = Color.grayText()
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews([
            topicImageView, verticalStackView
        ])
        verticalStackView.addArrangedSubviews([
            titleLabel,
            detailsLabel
        ])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        horizontalStackView.snp.makeConstraints {
            $0.size.equalToSuperview().offset(-32)
            $0.center.equalToSuperview()
        }
    }
}
