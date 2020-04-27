//
//  SandboxVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol SandboxVMProtocol: ViewModelProtocol where FinishCompletionReason == NSNull {
    var equationsListObservable: Observable<[SandboxEquation]> { get }
    var equationsList: [SandboxEquation] { get set }
}

class SandboxVM: BaseVM<NSNull>, SandboxVMProtocol {
    
    
    // MARK: - Properties
    
    private let equationsListSubject = BehaviorSubject<[SandboxEquation]>(value: [])
    var equationsListObservable: Observable<[SandboxEquation]> {
        equationsListSubject.asObservable()
    }
    var equationsList: [SandboxEquation] {
        get { try! equationsListSubject.value() }
        set { equationsListSubject.onNext(newValue) }
    }
    
}
