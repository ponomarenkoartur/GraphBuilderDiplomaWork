//
//  TopicContainerDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 28.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicsContainerDataBinder:
    BaseViewModelViewDataBinder<TopicsContainerVM, TopicsContainerVCProtocol> {
    
    override func bind() {
        viewModel.rx.topicsList
            .subscribe(onNext: { topicsList in
                self.views.forEach { $0.topicsList = topicsList }
            })
            .disposed(by: bag)
        viewModel.rx.selectedTopicIndex
            .subscribe(onNext: { index in
                self.views.forEach { $0.selectedTopicIndex = index }
            })
            .disposed(by: bag)
        
        views.forEach { view in
            view.didTapPreviousTopic = viewModel.previousTopic
            view.didTapNextTopic = viewModel.nextTopic
            view.didScrollToPage = { index in
                self.viewModel.selectedTopicIndex = index
            }
        }
    }
}
