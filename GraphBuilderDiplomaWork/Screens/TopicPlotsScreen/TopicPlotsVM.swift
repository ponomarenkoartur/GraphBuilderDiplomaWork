//
//  TopicPlotsVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 23.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol TopicPlotsVMProtocol: ViewModelProtocol {
    var plotsList: Observable<[Plot]> { get }
    var selectedPlotIndex: Observable<Int?> { get }
    var topicTitle: Observable<String?> { get }
    var plotTitle: Observable<String?> { get }
    func setSelectedPlotIndex(_ index: Int) throws
    func nextPlot() throws
    func previousPlot() throws
}

class TopicPlotsVM: BaseVM<NSNull>, TopicPlotsVMProtocol {
    
    
    enum Error: Swift.Error {
        case plotWithSuchIndexDoesntExists
    }
        
    
    // MARK: - Properties
    
    private let plotsListSubject = BehaviorSubject<[Plot]>(value: [])
    var plotsList: Observable<[Plot]> { plotsListSubject.asObservable() }
    private var plotsListValue: [Plot] {
        (try? plotsListSubject.value()) ?? []
    }
    
    private let selectedPlotIndexSubject = BehaviorSubject<Int?>(value: nil)
    var selectedPlotIndex: Observable<Int?> {
        selectedPlotIndexSubject.asObservable()
    }
    private var selectedPlotIndexValue: Int? {
        try? selectedPlotIndexSubject.value()
    }
    
    private let topicTitleSubject = BehaviorSubject<String?>(value: nil)
    private let plotTitleSubject = BehaviorSubject<String?>(value: nil)
    var topicTitle: Observable<String?> { topicTitleSubject.asObservable() }
    var plotTitle: Observable<String?> { plotTitleSubject.asObservable() }
    
    
    // MARK: - API Methods
    
    func setSelectedPlotIndex(_ index: Int) throws {
        guard plotsListValue.hasIndex(index) else {
            throw Error.plotWithSuchIndexDoesntExists
        }
        selectedPlotIndexSubject.onNext(index)
    }
    
    func nextPlot() throws {
        guard let index = selectedPlotIndexValue else { return }
        try setSelectedPlotIndex(index + 1)
    }
    
    func previousPlot() throws {
        guard let index = selectedPlotIndexValue else { return }
        try setSelectedPlotIndex(index - 1)
    }
    
    func setPlotList(_ list: [Plot]) {
        plotsListSubject.onNext(list)
        if !list.isEmpty {
            try? setSelectedPlotIndex(0)            
        }
    }
}
