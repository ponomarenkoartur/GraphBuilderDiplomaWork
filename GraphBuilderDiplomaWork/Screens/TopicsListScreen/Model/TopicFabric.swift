//
//  TopicFabric.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import FirebaseDatabase
import Foundation
import Alamofire


class TopicFabric {
    
    
    // MARK: - Constants
    
    enum KeyPath: String {
        case title, shortDescription, content
    }
    
    
    // MARK: - API Methods
    
    func createTopic(from snapshot: DataSnapshot) -> Topic? {
        guard let title = snapshot
            .childSnapshot(forPath: KeyPath.title).value as? String,
            let description = snapshot
                .childSnapshot(forPath: KeyPath.shortDescription)
                .value as? String else {
                    return nil
        }
        
        let content = parseContent(from: snapshot)
        return Topic(title: title, shortDescription: description,
                     content: content)
    }
    
    
    // MARK: - Private Methods
    
    private func parseContent(
        from snapshot: DataSnapshot) -> [TopicContentItem] {
        let contentSnapshot = snapshot.childSnapshot(forPath: KeyPath.content)
        let fabric = TopicContentFabric()
        return contentSnapshot.children.allObjects
            .compactMap { $0 as? DataSnapshot }
            .sorted { (Int($0.key) ?? 0) < (Int($1.key) ?? 0) }
            .compactMap { fabric.create(from: $0) }
    }
}


extension DataSnapshot {
    func childSnapshot<T: RawRepresentable>(forPath path: T) -> DataSnapshot
        where T.RawValue == String {
        childSnapshot(forPath: path.rawValue)
    }
}
