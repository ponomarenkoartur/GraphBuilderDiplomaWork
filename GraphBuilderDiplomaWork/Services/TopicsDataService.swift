//
//  TopicsDataService.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift
import FirebaseDatabase


protocol TopicsDataServiceProtocol {
    var topics: [Topic] { get }
    func fetchData(_ completion: @escaping (_ error: Error?) -> ())
}

class TopicsDataService: TopicsDataServiceProtocol {
    
    
    // MARK: - Singleton
    
    static let shared = TopicsDataService()
    private init() {}
    
    
    // MARK: - Constants
    
    private static let topicsReferencePath = "topics"
    
    
    // MARK: - Properties
    
    private let ref = Database.database().reference()
        .child(TopicsDataService.topicsReferencePath)
    fileprivate let topicsSubject = BehaviorSubject<[Topic]>(value: [])
    private(set) var topics: [Topic] {
        get { try! topicsSubject.value() }
        set { topicsSubject.onNext(newValue) }
    }
    
    
    // MARK: - API Methods
    
    func fetchData(_ completion: @escaping (_ error: Error?) -> ()) {
        
        let topicFabric = TopicFabric()
        
        ref.observe(.value) { snapshot in
            let topicsListSnapshot = snapshot.children.allObjects
                .compactMap { $0 as? DataSnapshot }
            self.topics = topicsListSnapshot.compactMap {
                topicFabric.createTopic(from: $0)
            }
            completion(nil)
        }
        
//        topics = [
//            Topic(title: "Hello",
//                  shortDescription: "This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. This is short description of \"Hello\" topic. ",
//                  content: [
//                    TopicSubheader(text: "Subheader of Hello"),
//            ]),
//
//            Topic(title: "World",
//                  shortDescription: "This is short description of \"World\" topic",
//                  content: [
//                    TopicSubheader(text: "Subheader of World"),
//                    TopicParagraph(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
//                    TopicIllustration(image: Image.topicPlaceholder()!, height: 100),
//                    TopicProccedToPlotBuildingItem(graph: "y+2"),
//                ]
//            ),
//            Topic(title: "!",
//                  shortDescription: "This is short description of \"!\" topic.",
//                  content: [
//                    TopicSubheader(text: "Subheader of !"),
//            ]),
//        ]
//        completion(nil)
    }
}



// MARK: - Rx

extension TopicsDataService: ReactiveCompatible {}

extension Reactive where Base == TopicsDataService {
    var topics: Observable<[Topic]> {
        base.topicsSubject.asObservable()
    }
}
