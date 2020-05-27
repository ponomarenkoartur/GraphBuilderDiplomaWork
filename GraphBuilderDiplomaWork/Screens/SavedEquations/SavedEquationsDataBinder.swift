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
        
        views.forEach { view in
            view.didTapDeleteEquationAt = { index in
                self.viewModel.deleteEquation(at: index)
            }
            view.didSelectEquationAt = { index in
                guard let equation = self.viewModel.equations[safe: index]
                    else { return }
                self.viewModel
                    .finishCompletion(.didSelectEquation(equation: equation))
            }
        }
        
    }
}
