//
//  BaseVM.swift
//  LimoDad
//
//  Created by artur_ios on 12.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift


class BaseVM<FinishCompletionReason>: NSObject, ViewModelProtocol {
    
    typealias FinishCompletionReason = FinishCompletionReason
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    var finishCompletion: (FinishCompletionReason) -> () = { _ in }
    
}
