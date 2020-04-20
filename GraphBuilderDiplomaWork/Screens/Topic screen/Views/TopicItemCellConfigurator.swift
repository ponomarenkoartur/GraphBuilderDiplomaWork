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
        case let subheader as TopicSubheader:
            if let subheaderCell = tableView
                .dequeue(TopicSubheaderCell.self, for: indexPath) {
                configureSubheaderCell(subheaderCell, subheader: subheader)
                cell = subheaderCell
            }
        default:
            break
        }
        
        return cell
    }
    
    
    // MARK: - Private Methods
    
    private func configureSubheaderCell(
        _ cell: TopicSubheaderCell, subheader: TopicSubheader) {
        cell.subheaderText = subheader.text
    }
    
    
    // MARK: - Static Methods
    
    static func cellClass(for item: Any) -> UITableViewCell.Type? {
        switch item {
        case is TopicSubheader:
            return TopicSubheaderCell.self
        default:
            return nil
        }
    }
}
