//
//  CompletableEvent extension.swift
//  LimoDad
//
//  Created by artur_ios on 20.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift


extension CompletableEvent {
    var isCompleted: Bool {
        if case .completed = self {
            return true
        } else {
            return false
        }
    }
    
    var error: Error? {
        if case .error(let error) = self {
            return error
        } else {
            return nil
        }
    }
}
