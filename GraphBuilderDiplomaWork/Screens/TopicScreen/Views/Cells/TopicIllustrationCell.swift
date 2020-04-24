//
//  TopicIllustrationCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class TopicIllustrationCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    var imageViewHeight: CGFloat? {
        didSet {
            guard let imageViewHeight = imageViewHeight else { return }
            
            // Check if constraint exists
            if illustrationImageView.constraints.contains(where: {
                $0.firstAnchor == illustrationImageView.heightAnchor
            }) {
                illustrationImageView.snp.updateConstraints {
                    $0.height.equalTo(imageViewHeight)
                }
            } else {
                illustrationImageView.snp.makeConstraints {
                    $0.height.equalTo(imageViewHeight)
                }
            }
        }
    }
    var illustrationImage: UIImage? {
        get { illustrationImageView.image }
        set { illustrationImageView.image = newValue }
    }
    
    // MARK: Views
    
    private lazy var illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override var imageView: UIImageView? { illustrationImageView }
    
    
    // MARK: - Setup Methods
    
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(illustrationImageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        illustrationImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().offset(-20)
        }
    }
}
