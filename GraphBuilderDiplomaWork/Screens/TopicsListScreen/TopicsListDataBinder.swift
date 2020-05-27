//
//  TopicsListDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicsListDataBinder:
    BaseViewModelViewDataBinder<TopicsListVM, TopicsListVCProtocol> {
    
    
    override func bind() {
        views.forEach { view in
            view.didSelectTopic = { index in
                guard let topic = self.viewModel.topics[safe: index]
                    else { return }
                self.viewModel.finishCompletion(
                    .didSelectTopic(topic: topic, index: index))
            }
        }
        
        viewModel.rx.topics
            .subscribe(onNext: { topics in
                self.views.forEach { $0.topics = topics }
            })
            .disposed(by: bag)
        
        viewModel.rx.isLoading
            .subscribe(onNext: { isLoading in
                self.views.forEach { $0.showLoading(isLoading) }
            })
            .disposed(by: bag)
        
        viewModel.rx.error
            .subscribe(onNext: { error in
                guard let error = error else { return }
                self.views.forEach {
                    $0.presentOkAlert(title: error.readableDescription)
                }
            })
            .disposed(by: bag)
    }
}
