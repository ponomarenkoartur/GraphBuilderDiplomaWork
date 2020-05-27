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
    var didSavePhoto: () -> () { get set }
    var didRequestPictureRecognitionVC: () -> () { get set }
    var didAddEquationRecognizedFromImage: () -> () { get set }
    var plotsList: [Plot] { get }
    var recognitionErrorText: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    func addPlot(_ plot: Plot)
    func removePlot(at index: Int)
    func updatePlotEquation(at index: Int, newEquation: String)
    func setMode(_ mode: PlotPresentationMode)
    func savePhotoToCameraRoll(_ image: UIImage)
    func takePictureToRecognize()
    func addPlots(fromImage image: UIImage)
    func discardError()
    func saveEquation(at index: Int)
}

class SandboxVM: BaseVM<NSNull>, SandboxVMProtocol {
    
    
    // MARK: - Properties
    
    private(set) var plotsList: [Plot] = []
    private(set) var mode: PlotPresentationMode = .vr
    private let equationRecognizer: EquationRecognizer = MathpixRecognizer()
    
    private let recognitionErrorTextSubject: BehaviorSubject<String?> =
        BehaviorSubject(value: nil)
    var recognitionErrorText: Observable<String?> {
        recognitionErrorTextSubject.asObservable()
    }
    
    private let isLoadingSubject = BehaviorSubject(value: false)
    var isLoading: Observable<Bool> { isLoadingSubject.asObservable() }
    
    
    // MARK: Callbacks
    
    var didAddPlot: (_ plot: Plot, _ index: Int) -> () = { _, _ in }
    var didRemovePlot: (_ plot: Plot, _ index: Int) -> () = { _, _ in }
    var didSetPlotList: (_ list: [Plot]) -> () = { _ in }
    var didSetPresentationMode: (_ mode: PlotPresentationMode) -> () = { _ in }
    var didUpdateParameterList: (_ plot: Plot, _ index: Int) -> () = { _, _ in }
    var didSavePhoto: () -> () = {}
    var didRequestPictureRecognitionVC: () -> () = {}
    var didAddEquationRecognizedFromImage: () -> () = {}
    
    
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
    
    func savePhotoToCameraRoll(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavedHandler), nil)
    }
    
    @objc
    private func imageSavedHandler(_ image: UIImage, error: NSError?, contextInfo: Any) {
        if error == nil {
            didSavePhoto()
        }
    }
    
    func takePictureToRecognize() {
        didRequestPictureRecognitionVC()
    }
    
    func addPlots(fromImage image: UIImage) {
        isLoadingSubject.onNext(true)
        equationRecognizer.recognize(image) { (result) in
            self.isLoadingSubject.onNext(false)
            if case .success(let equations) = result, !equations.isEmpty {
                equations.forEach { self.addPlot(Plot(equation: $0)) }
                self.didAddEquationRecognizedFromImage()
            } else {
                self.recognitionErrorTextSubject
                    .onNext("No equation is recognized from the image")
            }
        }
    }
    
    func discardError() {
        recognitionErrorTextSubject.onNext(nil)
    }
    
    func saveEquation(at index: Int) {
        guard let plot = plotsList[safe: index] else { return }
        let equation = plot.equation
        DataService.shared.addEquation(equation)
    }
}
