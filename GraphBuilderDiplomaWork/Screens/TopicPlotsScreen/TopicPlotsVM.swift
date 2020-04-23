//
//  TopicPlotsVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol TopicPlotsVMProtocol: ViewModelProtocol {
    var graphList: Observable<[String]> { get }
    var selectedPlotIndex: Observable<Int?> { get }
}

class TopicPlotsVM: BaseVM<NSNull>, TopicPlotsVMProtocol {
    
        
    
    // MARK: - Properties
    
    private let graphListSubject = BehaviorSubject<[String]>(value: [])
    var graphList: Observable<[String]> { graphListSubject.asObservable() }
    
    private let selectedPlotIndexSubject = BehaviorSubject<Int?>(value: nil)
    var selectedPlotIndex: Observable<Int?> {
        selectedPlotIndexSubject.asObservable()
    }
}
