//
//  Plot.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class Plot {
    
    // MARK: - Properties
    
    var title: String {
        get { try! titleSubject.value() }
        set { titleSubject.onNext(newValue) }
    }
    var equation: Equation {
        get { try! equationSubject.value() }
        set { equationSubject.onNext(newValue) }
    }
    var color: UIColor {
        get { try! colorSubject.value() }
        set { colorSubject.onNext(newValue) }
    }
    var isHidden: Bool {
        get { try! isHiddenSubject.value() }
        set { isHiddenSubject.onNext(newValue) }
    }
    var error: Error? {
        get { try? errorSubject.value() }
        set { errorSubject.onNext(newValue) }
    }
    
    // MARK: Rx
    
    fileprivate let titleSubject: BehaviorSubject<String>
    fileprivate let equationSubject: BehaviorSubject<Equation>
    fileprivate let colorSubject: BehaviorSubject<UIColor>
    fileprivate let isHiddenSubject: BehaviorSubject<Bool>
    fileprivate let errorSubject = BehaviorSubject<Error?>(value: nil)
    
    
    // MARK: - Initialization
    
    init(title: String = "", equation: Equation,
         color: UIColor = PlotColorPickerView.randomColor(),
         isHidden: Bool = false) {
        titleSubject = BehaviorSubject(value: title)
        equationSubject = BehaviorSubject(value: equation)
        colorSubject = BehaviorSubject(value: color)
        isHiddenSubject = BehaviorSubject(value: isHidden)
    }
}


extension Plot: Equatable {
    static func == (lhs: Plot, rhs: Plot) -> Bool {
        lhs === rhs
    }
}


extension Plot: Hashable {
    func hash(into hasher: inout Hasher) {
        (title + equation.latex).hash(into: &hasher)
    }
}

extension Plot: ReactiveCompatible {}

extension Reactive where Base: Plot {
    var title: Observable<String> { base.titleSubject.asObservable() }
    var equation: Observable<Equation> { base.equationSubject.asObservable() }
    var color: Observable<UIColor> { base.colorSubject.asObservable() }
    var isHidden: Observable<Bool> { base.isHiddenSubject.asObservable() }
    var error: Observable<Error?> { base.errorSubject.asObservable() }
}
