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
    let item: CellPresentable


    // MARK: - API Methods
    
    func configure(for indexPath: IndexPath) -> UITableViewCell? {
        let cellType = item.cellPresentation
        let cell = tableView.dequeue(cellType, for: indexPath) ?? cellType.init()
        
        if cellType == TopicSubheaderCell.self,
            let cell = cell as? TopicSubheaderCell {
            configureSubheaderCell(cell)
        }
        
        return cell
    }
    
    
    // MARK: - Private Methods
    
    private func configureSubheaderCell(_ cell: TopicSubheaderCell) {
        print("Configuring subheader cell")
    }
}
