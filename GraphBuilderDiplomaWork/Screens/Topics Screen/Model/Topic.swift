//
//  Topic.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


struct Topic {
    
    
    // MARK: - Properties
    
    let title: String
    let shortDescription: String?
    let imagePreview: UIImage?
    let items: [CellPresentable]
    
    
    // MARK: - Initialization
    
    init(title: String, shortDescription: String?, imagePreview: UIImage? = nil,
         items: [CellPresentable] = []) {
        self.title = title
        self.shortDescription = shortDescription
        self.imagePreview = imagePreview
        self.items = items
    }
}
