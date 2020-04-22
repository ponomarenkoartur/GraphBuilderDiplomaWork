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
    
    private let serialPositionSubject: BehaviorSubject<SerialPosition?>
    var serialPosition: Observable<SerialPosition?> {
        serialPositionSubject.asObservable()
    }
    
    
    // MARK: - Initialization
    
    init(topic: Topic, serialPosition: SerialPosition?,
         view: TopicVC? = TopicVC()) {
        self.serialPositionSubject = BehaviorSubject(value: serialPosition)
        self.topicSubject = BehaviorSubject(value: topic)
        super.init(view: view)
        setupViewController(view)
    }
    
    
    // MARK: - Setup Methods
    
    private func setupViewController(_ vc: TopicVC?) {
        vc?.topic = self.topic
        vc?.serialPosition = serialPosition
    }
    
}
