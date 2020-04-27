//
//  SandboxDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxDataBinder<ViewModel>:
    BaseViewModelViewDataBinder<ViewModel, SandboxVCProtocol>
    where ViewModel: SandboxVMProtocol {
    
    
    override func bind() {
        viewModel.equationsListObservable
            .subscribe(onNext: { list in
                self.views.forEach { $0.setEquationsList(list) }
            })
            .disposed(by: bag)
        
        views.forEach { (view) in
            view.didTapShowPlot = { show, index in
                var list = self.viewModel.equationsList
                list[index].isHidden = !show
                self.viewModel.equationsList = list
            }
        }
    }
}
