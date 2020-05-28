//
//  TopicFabric.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import FirebaseDatabase


class TopicFabric {
    
    
    // MARK: - Constants
    
    enum KeyPath: String {
        case title, shortDescription
    }
    
    
    // MARK: - API Methods
    
    func createTopic(from snapshot: DataSnapshot) -> Topic? {
        guard let title = snapshot
            .childSnapshot(forPath: KeyPath.title.rawValue).value as? String,
            let description = snapshot
                .childSnapshot(forPath: KeyPath.shortDescription.rawValue)
                .value as? String else {
                    return nil
        }
        return Topic(title: title, shortDescription: description)
    }
}
