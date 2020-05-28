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
    
    var illustrationImage: UIImage? {
        get { illustrationImageView.image }
        set {
            illustrationImageView.image = newValue
            updateImageViewHeightConstraint()
        }
    }
    
    // MARK: Callbacks
    
    var didUpdateSize: () -> () = {}
    
    
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
            $0.width.equalToSuperview().offset(-20)
            $0.height.equalToSuperview().offset(-20)
        }
    }
    
    
    // MARK: - API Methods
    
    func setImage(byURL url: URL) {
        illustrationImageView.setImage(byURL: url, placeholderImage: nil) {
            self.updateImageViewHeightConstraint()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func updateImageViewHeightConstraint() {
        let height: CGFloat
        if let image = illustrationImage {
            height = illustrationImageView.frame.width * image.size.aspectRatio
        } else {
            height = 0
        }
        
        // Update size of imageView
        if illustrationImageView.constraints.contains(where: {
            $0.firstAnchor == illustrationImageView.heightAnchor
        }) {
            illustrationImageView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        } else {
            illustrationImageView.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        }
        didUpdateSize()
    }
}
