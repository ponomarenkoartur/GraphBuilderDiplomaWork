//
//  TopicsContainerCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit

class TopicsContainerCell: BaseCollectionCell {
    
    
    // MARK: - Properties
    
    // MARK: Views
    
    let viewController = TopicVC()
    
    
    // MARK: - Setup Methods
    
    override func addSubviews() {
        super.addSubviews()
        contentView.addSubview(viewController.view)
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
