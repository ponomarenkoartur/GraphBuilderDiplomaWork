//
//  TopicSubheader.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


struct TopicSubheader: CellPresentable {
    

    // MARK: - Properties
    
    let text: String
    
    
    // MARK: - CellPresentable
    
    var cellPresentation: UITableViewCell.Type { TopicSubheaderCell.self }
}
