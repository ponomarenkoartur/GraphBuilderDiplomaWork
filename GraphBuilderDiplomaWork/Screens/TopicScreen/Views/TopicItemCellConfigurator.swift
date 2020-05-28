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
    let item: TopicContentItem


    // MARK: - API Methods
    
    func configure(for indexPath: IndexPath) -> UITableViewCell? {
        guard let cellClass = Self.cellClass(for: item),
            let cell = tableView.dequeue(cellClass, for: indexPath) else {
            return nil
        }
        
        switch (cell, item) {
        case (let cell as TopicSubheaderCell, let subheader as TopicSubheader):
            configureSubheaderCell(cell, subheader: subheader)
        case (let cell as TopicParagraphCell, let paragraph as TopicParagraph):
            configureParagraphCell(cell, paragraph: paragraph)
        case (let cell as TopicIllustrationCell,
              let illustration as TopicIllustration):
            configureIllustrationCell(cell, illustration: illustration,
                                      indexPath: indexPath)
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
    
    private func configureParagraphCell(
        _ cell: TopicParagraphCell, paragraph: TopicParagraph) {
        if let attributedText = paragraph.attributedText {
            cell.paragraphAttributedText = attributedText
        } else {
            cell.paragraphText = paragraph.text
        }
    }
    
    private func configureIllustrationCell(
        _ cell: TopicIllustrationCell, illustration: TopicIllustration,
        indexPath: IndexPath) {
        if let image = illustration.image {
            cell.illustrationImage = image
        } else if let url = illustration.imageURL {
            cell.setImage(byURL: url)
        }
        cell.didUpdateSize = {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // MARK: - Static Methods
    
    static func cellClass(for item: Any) -> UITableViewCell.Type? {
        switch item {
        case is TopicSubheader:
            return TopicSubheaderCell.self
        case is TopicParagraph:
            return TopicParagraphCell.self
        case is TopicIllustration:
            return TopicIllustrationCell.self
        case is TopicProccedToPlotBuildingItem:
            return TopicProccedToPlotBuildingCell.self
        default:
            return nil
        }
    }
}
