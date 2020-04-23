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
    var topicTitle: Observable<String?> { get }
    var graphTitle: Observable<String?> { get }
    func setSelectedPlotIndex(_ index: Int)
}

class TopicPlotsVM: BaseVM<NSNull>, TopicPlotsVMProtocol {
    
        
    
    // MARK: - Properties
    
    private let graphListSubject = BehaviorSubject<[String]>(value: [])
    var graphList: Observable<[String]> { graphListSubject.asObservable() }
    
    private let selectedPlotIndexSubject = BehaviorSubject<Int?>(value: nil)
    var selectedPlotIndex: Observable<Int?> {
        selectedPlotIndexSubject.asObservable()
    }
    
    var topicTitleSubject = BehaviorSubject<String?>(value: nil)
    var graphTitleSubject = BehaviorSubject<String?>(value: nil)
    var topicTitle: Observable<String?> { topicTitleSubject.asObservable() }
    var graphTitle: Observable<String?> { graphTitleSubject.asObservable() }
    
    
    // MARK: - API Methods
    
    func setSelectedPlotIndex(_ index: Int) {
        selectedPlotIndexSubject.onNext(index)
    }
    
    func setPlotList(_ list: [String]) {
        graphListSubject.onNext(list)
    }
}
