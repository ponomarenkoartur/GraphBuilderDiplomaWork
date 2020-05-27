//
//  SavedEquationsVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol SavedEquationsVMProtocol: ViewModelProtocol, ReactiveCompatible {
    var equations: [Equation] { get }
}

class SavedEquationsVM: BaseVM<SavedEquationsVM.FinishReason>, SavedEquationsVMProtocol {
    
    
    // MARK: - Enums
    
    enum FinishReason {
        case didSelectEquation(equation: Equation)
    }
    
    
    // MARK: - Properties
    
    fileprivate let equationsSubject = BehaviorSubject<[Equation]>(value: [])
    var equations: [Equation] {
        get { try! equationsSubject.value() }
        set { equationsSubject.onNext(newValue) }
    }
    
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        fetchEquations()
    }
    
    
    // MARK: - Setup Methods
    
    private func fetchEquations() {
        equations = DataService.shared.getEquations()
    }
}


// MARK: - Rx

extension Reactive where Base: SavedEquationsVMProtocol  {
    var equations: Observable<[Equation]> { fatalError() }
}

extension Reactive where Base == SavedEquationsVM  {
    var equations: Observable<[Equation]> {
        base.equationsSubject.asObservable()
    }
}
