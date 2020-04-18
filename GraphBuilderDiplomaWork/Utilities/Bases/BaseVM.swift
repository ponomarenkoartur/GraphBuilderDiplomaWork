//
//  BaseVM.swift
//  LimoDad
//
//  Created by artur_ios on 12.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift


class BaseVM<VC, FinishCompletionReason>: NSObject, ViewModelProtocol where VC: BaseVC {
    
    typealias FinishCompletionReason = FinishCompletionReason
    typealias View = VC
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    var viewController: View
    var finishCompletion: (FinishCompletionReason) -> () = { _ in }
    
    
    // MARK: - Initialization
    
    init(view: View = View()) {
        self.viewController = view
        super.init()
    }
}
