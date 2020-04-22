//
//  TopicVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicVM: BaseVM<TopicVC, NSNull> {
    
    
    // MARK: - Properties
    
    private let topicSubject: BehaviorSubject<Topic>
    var topic: Observable<Topic> { topicSubject.asObservable() }
    var topicItems: Observable<[TopicContentItem]> { topic.map { $0.content } }
    
    
    // MARK: - Initialization
    
    init(topic: Topic, view: TopicVC? = TopicVC()) {
        self.topicSubject = BehaviorSubject<Topic>(value: topic)
        super.init(view: view)
        view?.topic = self.topic
    }
    
}
