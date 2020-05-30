//
//  SavedEquationsVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol SavedEquationsVMProtocol: ViewModelProtocol, ReactiveCompatible {
    var equations: [SelectiveItem<Equation>] { get }
    var selectedEquations: [Equation] { get }
    func deleteEquation(at index: Int)
    func setSelectedEquation(at index: Int, isSelected: Bool)
}

class SavedEquationsVM: BaseVM<SavedEquationsVM.FinishReason>,
    SavedEquationsVMProtocol {
    
    
    // MARK: - Enums
    
    enum FinishReason {
        case didSelectEquations(equations: [Equation])
    }
    
    
    // MARK: - Properties
    
    fileprivate let equationsSubject =
        BehaviorSubject<[SelectiveItem<Equation>]>(value: [])
    var equations: [SelectiveItem<Equation>] {
        get { try! equationsSubject.value() }
        set { equationsSubject.onNext(newValue) }
    }
    var selectedEquations: [Equation] {
        equations.filter { $0.isSelected }.map { $0.item }
    }
    
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        fetchEquations()
    }
    
    
    // MARK: - Setup Methods
    
    private func fetchEquations() {
        equations = EquationDataService.shared.getEquations().map {
            SelectiveItem(item: $0, isSelected: false)
        }
    }
    
    
    // MARK: - API Methods
    
    func deleteEquation(at index: Int) {
        equations.remove(at: index)
        EquationDataService.shared.removeEquation(at: index)
    }
    
    func setSelectedEquation(at index: Int, isSelected: Bool) {
        equations[safe: index]?.isSelected = isSelected
    }
    
}


// MARK: - Rx

extension Reactive where Base == SavedEquationsVM  {
    var equations: Observable<[SelectiveItem<Equation>]> {
        base.equationsSubject.asObservable()
    }
}
