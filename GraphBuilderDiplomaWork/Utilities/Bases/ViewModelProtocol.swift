//
//  BaseVMProtocol.swift
//  p138
//
//  Created by artur_ios on 15.01.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import Foundation

protocol ViewModelProtocol: class {
    associatedtype View
    associatedtype FinishCompletionReason
    
    var viewController: View? { get }
    var finishCompletion: (_ reason: FinishCompletionReason) -> () { get set }
}
