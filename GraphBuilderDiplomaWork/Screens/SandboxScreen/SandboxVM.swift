//
//  SandboxVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol SandboxVMProtocol: ViewModelProtocol {
    var equationsList: Observable<[Equation]> { get }
    func setEquationList(_ list: [Equation])
}

class SandboxVM: BaseVM<NSNull>, SandboxVMProtocol {
    
    
    // MARK: - Properties
    
    private let equationsListSubject = BehaviorSubject<[Equation]>(value: [])
    var equationsList: Observable<[Equation]> {
        equationsListSubject.asObservable()
    }
    
    
    // MARK: - API Methods
    
    func setEquationList(_ list: [Equation]) {
        equationsListSubject.onNext(list)
    }
    
    
}
