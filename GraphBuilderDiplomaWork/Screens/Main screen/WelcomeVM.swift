//
//  WelcomeVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class WelcomeVM: BaseVM<WelcomeVC, WelcomeVM.FinishCompletionReason> {
    
    enum FinishCompletionReason {
        case didTapTopics, didTapSandbox
    }
    
    
    // MARK: - Properties
    
    let menuItems = ["Topics", "Sandbox"]
    
    
    // MARK: - Initialization
    
    override init(view: View? = View()) {
        super.init(view: view)
        view?.menuItems = menuItems
        view?.didSelectRow = { index in
            if let item = self.menuItems[safe: index],
                let reason = self.finishCompletionReason(for: item) {
                self.finishCompletion(reason)
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func finishCompletionReason(for menuItem: String) -> FinishCompletionReason? {
        switch menuItem {
        case menuItems[0]:
            return .didTapTopics
        case menuItems[1]:
            return .didTapSandbox
        default:
            return nil            
        }
    }
}
