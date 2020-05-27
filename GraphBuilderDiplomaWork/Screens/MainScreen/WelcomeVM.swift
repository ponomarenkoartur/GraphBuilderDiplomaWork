//
//  WelcomeVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol WelcomeVMProtocol: ViewModelProtocol, ReactiveCompatible {
    func finishWithReason(at index: Int)
}

class WelcomeVM: BaseVM<WelcomeVM.FinishCompletionReason>, WelcomeVMProtocol {
    
    enum FinishCompletionReason {
        case didTapTopics, didTapSandbox, didTapSavedEquations
    }
    
    
    // MARK: - Properties
    
    let menuItems = ["Topics", "Sandbox", "Saved equations"]
    
    
    // MARK: - API Methods
    
    func finishWithReason(at index: Int) {
        if let item = self.menuItems[safe: index],
            let reason = self.finishCompletionReason(for: item) {
            self.finishCompletion(reason)
        }
    }
    
    // MARK: - Private Methods
    
    private func finishCompletionReason(for menuItem: String)
        -> FinishCompletionReason? {
        switch menuItem {
        case menuItems[0]:
            return .didTapTopics
        case menuItems[1]:
            return .didTapSandbox
        case menuItems[2]:
            return .didTapSavedEquations
        default:
            return nil            
        }
    }
}


// MARK: - Rx

extension Reactive where Base == WelcomeVM {
    var menuItems: Observable<[String]> {
        Observable.just(base.menuItems)
    }
}
