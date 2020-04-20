//
//  TopicItemCellConfigurator.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


struct TopicItemCellConfigurator {
    
    // MARK: - Properties
    
    let tableView: UITableView
    let item: Any


    // MARK: - API Methods
    
    func configure(for indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        
        switch item {
        case is TopicSubheader:
            if let subheaderCell = tableView.dequeue(TopicSubheaderCell.self,
                                                     for: indexPath) {
                configureSubheaderCell(subheaderCell)
                cell = subheaderCell
            }
        default:
            break
        }
        
        return cell
    }
    
    
    // MARK: - Private Methods
    
    private func configureSubheaderCell(_ cell: TopicSubheaderCell) {
        print("Configuring subheader cell")
    }
}
