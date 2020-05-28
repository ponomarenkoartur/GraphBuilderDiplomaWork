//
//  TopicIllustration.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


struct TopicIllustration {
    
    
    // MARK: - Properties
    
    let image: UIImage?
    let imageURL: URL?
    let height: CGFloat?
    
    
    // MARK: - Initialization
    
    init(image: UIImage? = nil, imageURL: URL? = nil, height: CGFloat? = nil) {
        self.image = image
        self.imageURL = imageURL
        self.height = height
    }
}


extension TopicIllustration: TopicContentItem {}
