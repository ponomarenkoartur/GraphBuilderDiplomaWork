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
        viewModel.didUpdateParameterList = { plot, index in
            DispatchQueue.main.async {
                self.views.forEach { $0.updateParametersOfPlot(at: index) }
            }
        }
        viewModel.didSetPresentationMode = { mode in
            DispatchQueue.main.async {
                self.views.forEach { $0.setPresentationMode(mode) }
            }
        }
        viewModel.didSavePhoto = {
            DispatchQueue.main.async {
                self.views.forEach { $0.performPhotoSavedAnimationAndSound() }
            }
        }
        viewModel.recognitionErrorText
            .subscribe(onNext: { errorText in
                guard let errorText = errorText else { return }
                self.views.forEach { view in
                    DispatchQueue.main.async {
                        view.presentOkAlert(title: errorText) {
                            self.viewModel.discardError()
                        }
                    }
                }
            })
            .disposed(by: bag)
        viewModel.isLoading
            .subscribe(onNext: { isLoading in
                self.views.forEach { $0.showLoading(isLoading) }
            })
            .disposed(by: bag)
        
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
            view.didTapChangeMode = { mode in
                self.viewModel.setMode(mode)
            }
            view.didTakePhoto = { image in
                self.viewModel.savePhotoToCameraRoll(image)
            }
            view.didTapRecognizeButton = {
                self.viewModel.takePictureToRecognize()
            }
        }
    }
}
