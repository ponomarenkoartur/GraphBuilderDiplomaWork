//
//  SandboxVM.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import RxSwift


protocol SandboxVMProtocol: ViewModelProtocol where FinishCompletionReason == NSNull {
    var didRemovePlot: (_ plot: Plot, _ index: Int) -> () { get set }
    var didAddPlot: (_ plot: Plot, _ index: Int) -> () { get set }
    var didSetPlotList: (_ list: [Plot]) -> () { get set }
    var didUpdateParameterList: (_ plot: Plot, _ index: Int) -> () { get set }
    var didSetPresentationMode: (_ mode: PlotPresentationMode) -> () { get set }
    var plotsList: [Plot] { get }
    func addPlot(_ plot: Plot)
    func removePlot(at index: Int)
    func updatePlotEquation(at index: Int, newEquation: String)
    func setMode(_ mode: PlotPresentationMode)
}

class SandboxVM: BaseVM<NSNull>, SandboxVMProtocol {
    
    
    // MARK: - Properties
    
    private(set) var plotsList: [Plot] = []
    private(set) var mode: PlotPresentationMode = .vr
    
    
    // MARK: Callbacks
    
    var didAddPlot: (_ plot: Plot, _ index: Int) -> () = { _, _ in }
    var didRemovePlot: (_ plot: Plot, _ index: Int) -> () = { _, _ in }
    var didSetPlotList: (_ list: [Plot]) -> () = { _ in }
    var didSetPresentationMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    var didUpdateParameterList: (_ plot: Plot, _ index: Int) -> () = { _, _ in }
    
    
    // MARK: - API Methods
    
    func addPlot(_ plot: Plot) {
        plotsList.append(plot)
        didAddPlot(plot, plotsList.lastIndex)
    }
    
    func removePlot(at index: Int) {
        let plot = plotsList[index]
        plotsList.remove(at: index)
        didRemovePlot(plot, index)
    }
    
    func setPlotList(_ list: [Plot]) {
        self.plotsList = list
        didSetPlotList(list)
    }
    
    func setMode(_ mode: PlotPresentationMode) {
        self.mode = mode
        didSetPresentationMode(mode)
    }
    
    func updatePlotEquation(at index: Int, newEquation: String) {
        let plot = plotsList[index]
        guard plot.equation.latex != newEquation else { return }
        let oldParameters = plot.equation.parameters
        plot.equation.setEquation(newEquation)
        let newParameters = plot.equation.parameters
        if oldParameters != newParameters {
            didUpdateParameterList(plot, index)
        }
    }
}
