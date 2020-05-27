//
//  TopicsDataService.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol TopicsDataServiceProtocol {
    func getTopics() -> [Topic]
    func fetchData(_ completion: @escaping (_ error: Error?) -> ())
}

class TopicsDataService: TopicsDataServiceProtocol {
    
    
    // MARK: - Singleton
    
    static let shared = TopicsDataService()
    private init() {}
    
    
    // MARK: - Properties
    
    private var topics: [Topic] = []
    
    
    // MARK: - API Methods
    
    func getTopics() -> [Topic] {
        topics
    }
    
    func fetchData(_ completion: @escaping (_ error: Error?) -> ()) {
        topics = [
            Topic(title: "Hello",
                  shortDescription: "This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. ",
                  content: [
                    TopicSubheader(text: "Subheader of Hello"),
            ]),
            
            Topic(title: "World",
                  shortDescription: "This is short description of \"World\" topic",
                  content: [
                    TopicSubheader(text: "Subheader of World"),
                    TopicParagraph(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                    TopicIllustration(image: Image.topicPlaceholder()!, height: 100),
                    TopicProccedToPlotBuildingItem(graph: "y+2"),
                ]
            ),
            Topic(title: "!",
                  shortDescription: "This is short description of \"!\" topic.",
                  content: [
                    TopicSubheader(text: "Subheader of !"),
            ]),
        ]
        completion(nil)
    }
}
