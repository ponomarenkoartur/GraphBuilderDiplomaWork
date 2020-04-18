//
//  SingleEvent extension.swift
//  LimoDad
//
//  Created by artur_ios on 27.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift

extension SingleEvent {
    var error: Error? {
        if case .error(let error) = self {
            return error
        } else {
            return nil
        }
    }
}
