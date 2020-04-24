//
//  TopicParagraph.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


struct TopicParagraph {
    
    
    // MARK: - Properties
    
    var text: String?
    var attributedText: NSAttributedString?
    
    
    // MARK: - Initialization
    
    init(text: String) {
        self.text = text
    }
    
    init(attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
}


extension TopicParagraph: TopicContentItem {}
