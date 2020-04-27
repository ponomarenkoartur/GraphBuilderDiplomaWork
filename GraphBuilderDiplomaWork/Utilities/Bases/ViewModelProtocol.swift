//
//  BaseVMProtocol.swift
//  p138
//
//  Created by artur_ios on 15.01.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import Foundation

protocol ViewModelProtocol: class {
    associatedtype FinishCompletionReason
    
    var finishCompletion: (_ reason: FinishCompletionReason) -> () { get set }
}


extension ViewModelProtocol where FinishCompletionReason == NSNull {
    var finishCompletion: () -> () {
        get { { self.finishCompletion(NSNull()) } }
        set { finishCompletion = { _ in newValue() } }
    }
}
