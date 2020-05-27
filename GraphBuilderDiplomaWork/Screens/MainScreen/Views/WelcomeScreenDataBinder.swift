//
//  WelcomeScreenDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class WelcomeScreenDataBinder:
    BaseViewModelViewDataBinder<WelcomeVM, WelcomeVCProtocol> {
    
    
    override func bind() {
        viewModel.rx.menuItems
            .subscribe(onNext: { menuItems in
                self.views.forEach { $0.menuItems = menuItems }
            })
            .disposed(by: bag)
        
        views.forEach { (view) in
            view.didSelectRow = { index in
                self.viewModel.finishWithReason(at: index)
            }
        }
    }
}
