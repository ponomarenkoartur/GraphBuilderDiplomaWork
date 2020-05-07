//
//  SandboxDataBinder.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 25.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class SandboxDataBinder<ViewModel>:
    BaseViewModelViewDataBinder<ViewModel, SandboxVCProtocol>
    where ViewModel: SandboxVMProtocol {
    
    
    override func bind() {
        viewModel.didAddPlot = { plot, _ in
            DispatchQueue.main.async {
                self.views.forEach { $0.addPlot(plot) }
            }
        }
        viewModel.didRemovePlot = { _, index in
            DispatchQueue.main.async {
                self.views.forEach { $0.removePlot(at: index) }
            }
        }
        viewModel.didSetPlotList = { list in
            DispatchQueue.main.async {
                self.views.forEach { $0.setPlotList(list) }
            }
        }
        
        views.forEach { (view) in
            view.didTapShowPlot = { show, index in
                self.viewModel.plotsList[index].isHidden = !show
            }
            view.didSelectColorForPlot = { color, index in
                self.viewModel.plotsList[index].color = color
            }
            view.didTapDeleteEquation = { index in
                self.viewModel.removePlot(at: index)
            }
            view.didTapBack = {
                self.viewModel.finishCompletion()
            }
            view.didTapAddPlot = {
                let fabric = PlotFabric()
                let plot = fabric.createEmpty()
                self.viewModel.addPlot(plot)
            }
            view.didChangeEquationText = { plot, index, text in
                self.viewModel.updatePlotEquation(at: index, newEquation: text)
            }
        }
    }
}
