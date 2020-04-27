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
        viewModel.equationsList
            .subscribe(onNext: { list in
                self.views.forEach { $0.setEquationsList(list) }
            })
            .disposed(by: bag)
    }
}
