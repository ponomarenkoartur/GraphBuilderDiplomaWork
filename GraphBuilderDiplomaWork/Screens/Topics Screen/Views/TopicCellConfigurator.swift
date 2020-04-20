//
//  TopicCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


struct TopicCellConfigurator {

    
    // MARK: - Properties
    
    let cell: TopicCell
    
    
    // MARK: - API Methods
    
    func configure(with topic: Topic) {
        cell.topicTitle = topic.title
        cell.detailsText = topic.shortDescription
        cell.topicImage = topic.imagePreview
    }
}
