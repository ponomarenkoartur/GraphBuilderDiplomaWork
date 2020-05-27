//
//  SavedEquationsDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


class SavedEquationsDataBinder:
    BaseViewModelViewDataBinder<SavedEquationsVM, SavedEquationsVCProtocol> {
    
    
    override func bind() {
        viewModel.rx.equations
            .subscribe(onNext: { equations in
                self.views.forEach { $0.setEquations(equations) }
            })
            .disposed(by: bag)
        
    }
}
