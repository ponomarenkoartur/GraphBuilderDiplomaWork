//
//  TopicContentFabric.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 28.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import FirebaseDatabase


class TopicContentFabric {

    
    // MARK: - Enums
    
    private enum TopicContentKey: String {
        case section, value, subheader, paragraph, imageURL, equation,
            equationButton
    }
    
    
    // MARK: - API Methods
    
    func create(from snapshot: DataSnapshot) -> TopicContentItem? {
        guard let children = snapshot.children.allObjects
            as? [DataSnapshot],
            let sectionSnapshot = children
                .first(where: { $0.key == TopicContentKey.section.rawValue }),
            let valueSnapshot = children
                .first(where: { $0.key == TopicContentKey.value.rawValue }),
            let section = sectionSnapshot.value as? String,
            let value = valueSnapshot.value as? String
            else { return nil }
        
        switch section {
        case TopicContentKey.subheader.rawValue:
            return TopicSubheader(text: value)
        case TopicContentKey.paragraph.rawValue:
            return TopicParagraph(text: value)
        case TopicContentKey.imageURL.rawValue:
            return TopicIllustration(imageURL: URL(string: value))
        case TopicContentKey.equation.rawValue:
            return TopicEquationItem(equation: value)
        case TopicContentKey.equationButton.rawValue:
            return TopicProccedToPlotBuildingItem(graph: value)
        default:
            return nil
        }
    }
}
