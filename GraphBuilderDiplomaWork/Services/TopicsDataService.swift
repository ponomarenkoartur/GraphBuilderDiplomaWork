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
    }
}



// MARK: - Rx

extension TopicsDataService: ReactiveCompatible {}

extension Reactive where Base == TopicsDataService {
    var topics: Observable<[Topic]> {
        base.topicsSubject.asObservable()
    }
}
