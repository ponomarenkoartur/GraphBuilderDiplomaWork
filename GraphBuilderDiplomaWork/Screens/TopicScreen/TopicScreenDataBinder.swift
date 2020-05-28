//
//  TopicScreenDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 28.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicScreenDataBinder: BaseViewModelViewDataBinder<TopicVM, TopicVCProtocol> {
    
    override func bind() {
        viewModel.rx.topic
            .subscribe(onNext: { topic in
                self.views.forEach { $0.topic = topic }
            })
            .disposed(by: bag)
        viewModel.rx.serialPosition
            .subscribe(onNext: { position in
                self.views.forEach { $0.setSerialPosition(position) }
            })
            .disposed(by: bag)
        
        views.forEach { view in
            view.didTapProceedToPlotBuildingItem = {
                self.viewModel
                    .finishCompletion(.didTapBuildPlotInSandbox(item: $0))
            }
        }
        
    }
}
