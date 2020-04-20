//
//  TopicSubheaderCell.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import AttributedString


class TopicSubheaderCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    var subheaderText: String? {
        get {
            textLabel?.text
        }
        set {
            textLabel?.attributed.text = """
            \(newValue ?? "", .font(Font.sfProDisplaySemibold(size: 15)!))
            """
        }
    }
}
