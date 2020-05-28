//
//  TopicsContainerVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicsContainerVM: BaseVM<TopicsContainerVM.FinishCompletionReason> {
    
    
    // MARK: - Enums
    
    enum FinishCompletionReason {
        case didTapBuildPlotInSandbox(item: TopicProccedToPlotBuildingItem)
    }
    
    
    // MARK: - Properties
    
    fileprivate var topicsListSubject: BehaviorSubject<[Topic]>
    var topicsList: [Topic] {
        get { try! topicsListSubject.value() }
        set { topicsListSubject.onNext(newValue) }
    }
    fileprivate var selectedTopicIndexSubject: BehaviorSubject<Int>
    var selectedTopicIndex: Int {
        get { try! selectedTopicIndexSubject.value() }
        set { selectedTopicIndexSubject.onNext(newValue) }
    }
    var selectedTopicIndexValue: Int? { try? selectedTopicIndexSubject.value() }
    
    
    // MARK: - Initialization
    
    init(topicsList: [Topic], selectedTopicIndex: Int) {
        topicsListSubject = BehaviorSubject(value: topicsList)
        selectedTopicIndexSubject = BehaviorSubject(value: selectedTopicIndex)
    }
    
    
    // MARK: - API Methods
    
    func nextTopic() {
        guard let index = self.selectedTopicIndexValue else { return }
        self.selectedTopicIndexSubject.onNext(index + 1)
    }
    
    func previousTopic() {
        guard let index = self.selectedTopicIndexValue else { return }
        self.selectedTopicIndexSubject.onNext(index - 1)
    }
}



// MARK: - Rx


extension Reactive where Base == TopicsContainerVM {
    var selectedTopicIndex: Observable<Int> {
        base.selectedTopicIndexSubject.asObservable()
    }
    var topicsList: Observable<[Topic]> {
        base.topicsListSubject.asObservable()
    }
}

