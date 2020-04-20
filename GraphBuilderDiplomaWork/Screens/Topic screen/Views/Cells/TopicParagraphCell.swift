//
//  TopicParagraphCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit

class TopicParagraphCell: BaseTableViewCell {
    
    
    // MARK: - Properties
    
    var paragraphText: String? {
        get {
            textLabel?.text
        }
        set {
            textLabel?.text = newValue
        }
    }
    
    var paragraphAttributedText: NSAttributedString? {
        get {
            textLabel?.attributedText
        }
        set {
            textLabel?.attributedText = newValue
        }
    }
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        textLabel?.numberOfLines = 0
        textLabel?.textColor = Color.grayText()
        textLabel?.textAlignment = .justified
        textLabel?.font = Font.sfProDisplayRegular(size: 13)
    }
    
    
}
