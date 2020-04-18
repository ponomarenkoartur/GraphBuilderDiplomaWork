//
//  Completion extension.swift
//  LimoDad
//
//  Created by artur_ios on 18.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift

extension Completable {
    static func createCompleted() -> Completable {
        create {
            $0(.completed)
            return Disposables.create()
        }
    }
    
    static func create(withError error: Error) -> Completable {
        create {
            $0(.error(error))
            return Disposables.create()
        }
    }
}
