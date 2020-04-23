//
//  TopicPlotsDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class TopicPlotsDataBinder:
    BaseViewModelViewDataBinder<TopicPlotsVM, TopicPlotsVCProtocol> {
    
    
    // MARK: - API Methods
    
    override func bind() {
        viewModel.graphList
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
    }
}
