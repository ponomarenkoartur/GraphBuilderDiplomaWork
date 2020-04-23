//
//  TopicPlotsDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class TopicPlotsDataBinder<ViewModel>:
    BaseViewModelViewDataBinder<ViewModel, TopicPlotsVCProtocol>
    where ViewModel: TopicPlotsVMProtocol {
    
    
    // MARK: - API Methods
    
    override func bind() {
        viewModel.plotsList
            .subscribe(onNext: { list in
                self.views.forEach { $0.setPlotList(list) }
            })
            .disposed(by: bag)
        
        viewModel.selectedPlotIndex
            .compactMap { $0 }
            .subscribe(onNext: { index in
                self.views.forEach { $0.setSelectedPlotIndex(index) }
            })
            .disposed(by: bag)
        
        Observable.combineLatest(viewModel.topicTitle, viewModel.plotTitle)
            .map { [$0, $1].compactMap { $0 }.joined(separator: " – ") }
            .subscribe(onNext: { fullTitle in
                self.views.forEach { $0.title = fullTitle }
            })
            .disposed(by: bag)
        
        views.forEach {
            $0.didChangeSelectedPlotIndex = { index in
                try? self.viewModel.setSelectedPlotIndex(index)
            }
            $0.didTapPreviousPlotButton = {
                try? self.viewModel.previousPlot()
            }
            $0.didTapNextPlotButton = {
                try? self.viewModel.nextPlot()
            }
        }
    }
}
