//
//  BaseVM.swift
//  LimoDad
//
//  Created by artur_ios on 12.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import RxSwift


class BaseVM: NSObject, BaseVMProtocol {
    
    
    // MARK: - Properties
    
    let bag = DisposeBag()
    
    
    // MARK: - Initialization
    
    override required init() {
        super.init()
    }
}
