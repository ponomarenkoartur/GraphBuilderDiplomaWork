//
//  TopicsListVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicsListVM: BaseVM<TopicsListVM.FinishCompletionReason> {
    
    
    // MARK: - Enums
    
    enum FinishCompletionReason {
        case didSelectTopic(topic: Topic, index: Int)
    }
    
    
    // MARK: - Properties
    
    fileprivate let topicsSubject = BehaviorSubject<[Topic]>(value:
        TopicsDataService.shared.getTopics()
    )
    
    var topics: [Topic] {
        get { try! topicsSubject.value() }
        set { topicsSubject.onNext(newValue) }
    }
    
    
    fileprivate let isLoadingSubject = BehaviorSubject(value: false)
    var isLoading: Bool {
        get { try! isLoadingSubject.value() }
        set { isLoadingSubject.onNext(newValue) }
    }
    
    fileprivate let errorSubject = BehaviorSubject<Error?>(value: nil)
    var error: Error? {
        get { try! errorSubject.value() }
        set { errorSubject.onNext(newValue) }
    }
    
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        isLoading = true
        TopicsDataService.shared.fetchData { error in
            self.error = error
            self.isLoading = false
            self.topics = TopicsDataService.shared.getTopics()
        }
    }
}


// MARK: - Rx

extension Reactive where Base == TopicsListVM {
    var topics: Observable<[Topic]> {
        base.topicsSubject.asObservable()
    }
    var isLoading: Observable<Bool> {
        base.isLoadingSubject.asObservable()
    }
    var error: Observable<Error?> {
        base.errorSubject.asObservable()
    }
}
