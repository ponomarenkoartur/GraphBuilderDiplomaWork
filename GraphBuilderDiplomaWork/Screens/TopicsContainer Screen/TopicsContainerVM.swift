//
//  TopicsContainerVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicsContainerVM: BaseVM<TopicsContainerVC, TopicsContainerVM.FinishCompletionReason> {
    
    
    // MARK: - Enums
    
    enum FinishCompletionReason {}
    
    
    // MARK: - Properties
    
    var topicsList: Observable<[Topic]>
    private var selectedTopicIndexSubject: BehaviorSubject<Int>
    var selectedTopicIndex: Observable<Int> {
        selectedTopicIndexSubject.asObservable()
    }
    var selectedTopicIndexValue: Int? { try? selectedTopicIndexSubject.value() }
    
    
    // MARK: - Initialization
    
    init(topicsList: Observable<[Topic]>, selectedTopicIndex: Int) {
        selectedTopicIndexSubject = BehaviorSubject(value: selectedTopicIndex)
        self.topicsList = topicsList
        super.init(view: TopicsContainerVC(topicsList: topicsList))
        setupViewController()
    }
    
    
    // MARK: - Setup Methods
    
    private func setupViewController() {
        viewController?.selectedTopicIndex = self.selectedTopicIndex
        viewController?.didTapPreviousTopic = previousTopic
        viewController?.didTapNextTopic = nextTopic
        viewController?.didScrollToPage = { index in
            self.selectedTopicIndexSubject.onNext(index)
        }
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
