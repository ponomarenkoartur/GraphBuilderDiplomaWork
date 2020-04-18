//
//  Single extension\.swift
//  LimoDad
//
//  Created by artur_ios on 24.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift


extension Single {
    static func create<T>(withError error: Error) -> Single<T> {
        Single<T>.create {
            $0(.error(error))
            return Disposables.create()
        }
    }
}
