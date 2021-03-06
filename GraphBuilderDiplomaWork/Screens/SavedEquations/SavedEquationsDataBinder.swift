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
                self.viewModel.setSelectedEquation(at: index, isSelected: true)
            }
            view.didDeselectEquationAt = { index in
                self.viewModel.setSelectedEquation(at: index, isSelected: false)
            }
            view.didTapConfirmSelection = {
                self.viewModel
                    .finishCompletion(.didSelectEquations(
                        equations: self.viewModel.selectedEquations))
            }
        }
    }
}
