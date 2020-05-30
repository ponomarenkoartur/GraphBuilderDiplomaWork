//
//  SelectiveItem.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 30.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift

class SelectiveItem<T> {
    
    // MARK: - Properties
    
    fileprivate var itemSubject: BehaviorSubject<T>
    fileprivate var isSelectedSubject: BehaviorSubject<Bool>
    
    var itemSubjectObservable: Observable<T> { itemSubject.asObservable() }
    var isSelectedObservable: Observable<Bool> {
        isSelectedSubject.asObservable()
    }
    
    var item: T {
        get { try! itemSubject.value() }
        set { itemSubject.onNext(newValue) }
    }
    var isSelected: Bool {
        get { try! isSelectedSubject.value() }
        set { isSelectedSubject.onNext(newValue) }
    }
    
    
    // MARK: - Initialization
    
    init(item: T, isSelected: Bool) {
        itemSubject = BehaviorSubject(value: item)
        isSelectedSubject = BehaviorSubject(value: isSelected)
    }
}
