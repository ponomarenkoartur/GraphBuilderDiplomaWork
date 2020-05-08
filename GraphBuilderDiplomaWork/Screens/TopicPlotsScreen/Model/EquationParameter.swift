//
//  EquationParameter.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


class EquationParameter {
    
    
    // MARK: - Properties
    
    var name: String {
        get { try! nameSubject.value() }
        set { nameSubject.onNext(newValue) }
    }
    var value: Double {
        get { try! valueSubject.value() }
        set {
            valueSubject.onNext(newValue)
            if newValue > maxValue {
                maxValue = newValue
            }
            if newValue < minValue {
                minValue = newValue
            }
        }
    }
    var minValue: Double {
        get { try! minValueSubject.value() }
        set {
            minValueSubject.onNext(newValue)
            if newValue > value {
                value = newValue
            }
            if newValue > maxValue {
                maxValue = newValue
            }
        }
    }
    var maxValue: Double {
        get { try! maxValueSubject.value() }
        set {
            maxValueSubject.onNext(newValue)
            if newValue < value {
                value = newValue
            }
            if newValue < minValue {
                minValue = newValue
            }
        }
    }
    
    
    // MARK: Rx
    
    fileprivate let nameSubject: BehaviorSubject<String>
    fileprivate let valueSubject: BehaviorSubject<Double>
    fileprivate let minValueSubject: BehaviorSubject<Double>
    fileprivate let maxValueSubject: BehaviorSubject<Double>
    
    
    // MARK: - Initialization
    
    init(name: String, value: Double, minValue: Double = -10,
         maxValue: Double = 10) {
        nameSubject = BehaviorSubject(value: name)
        valueSubject = BehaviorSubject(value: value)
        minValueSubject = BehaviorSubject(value: minValue)
        maxValueSubject = BehaviorSubject(value: maxValue)
    }
}


// MARK: - Rx

extension EquationParameter: ReactiveCompatible {}

extension Reactive where Base: EquationParameter  {
    var name: Observable<String> { base.nameSubject }
    var value: Observable<Double> { base.valueSubject }
    var minValue: Observable<Double> { base.minValueSubject }
    var maxValue: Observable<Double> { base.maxValueSubject }
}


// MARK: - Equatable

extension EquationParameter: Equatable {
    static func == (lhs: EquationParameter,
                    rhs: EquationParameter) -> Bool {
        lhs.name == rhs.name &&
        lhs.value == rhs.value &&
        lhs.minValue == rhs.minValue &&
        lhs.maxValue == rhs.maxValue
    }
}

// MARK: Hashable

extension EquationParameter: Hashable {
    func hash(into hasher: inout Hasher) {
        "\(name)\(value)\(minValue)\(maxValue)".hash(into: &hasher)
    }
}
