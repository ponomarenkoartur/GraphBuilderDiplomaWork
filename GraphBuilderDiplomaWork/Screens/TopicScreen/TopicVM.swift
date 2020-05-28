//
//  TopicVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 20.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicVM: BaseVM<TopicVM.FinishCompletionReason> {
    
    
    // MARK: - Enums
    
    enum FinishCompletionReason {
        case didTapBuildPlotInSandbox(item: TopicProccedToPlotBuildingItem)
    }
    
    
    // MARK: - Properties
    
    fileprivate let topicSubject: BehaviorSubject<Topic>
    var topic: Topic {
        get { try! topicSubject.value() }
        set { topicSubject.onNext(newValue) }
    }
    
    fileprivate let serialPositionSubject: BehaviorSubject<SerialPosition?>
    var serialPosition: SerialPosition? {
        get { try! serialPositionSubject.value() }
        set { serialPositionSubject.onNext(newValue) }
    }
    
    
    init(topic: Topic, position: SerialPosition?) {
        topicSubject = BehaviorSubject(value: topic)
        serialPositionSubject = BehaviorSubject(value: position)
    }
}


// MARK: - Rx

extension Reactive where Base == TopicVM {
    var serialPosition: Observable<SerialPosition?> {
        base.serialPositionSubject.asObservable()
    }
    var topic: Observable<Topic> {
        base.topicSubject.asObservable()
    }
    var topicItems: Observable<[TopicContentItem]> {
        topic.map { $0.content }
    }
}
