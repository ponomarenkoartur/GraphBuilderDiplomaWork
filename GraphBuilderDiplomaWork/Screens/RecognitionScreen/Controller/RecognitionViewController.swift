//
//  RecognitionViewController.swift
//  EquationRecognition
//
//  Created by artur_ios on 19.11.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import UIKit
import MobileCoreServices
//import MathpixClient
import SnapKit
import ARKit
//import WolframAlpha


class RecognitionViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var contentView = RecognitionContentView()
    
    private var arView: GraphARSCNView {
        return contentView.arView
    }
    
    private var selectedImage: UIImage?
    private var equationRecognizer = FakeRecognizer()
    private var equations: [Equation] = []
    private var transformator = EquationTransformator()
    
    
    // MARK: - View Lifecycle
    
    
    override func loadView() {
        super.loadView()
        view = contentView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        arView.session.run(ARWorldTrackingConfiguration())
//        WolframAlpha.shared.queryData(query: "Table[i^2, {i, 0, 20, 2}]") { result in
//            switch result {
//            case .Success(let data):
//                print(String.init(data: data as Data, encoding: .utf8))
//            case .Failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    
    // MARK: - Setup Methods
    
    private func setupContentView() {
        contentView.dataSource = self
        contentView.delegate = self
        contentView.tappedCallback = {
            let image = self.contentView.arView.snapshot()
            self.selectedImage = image
            self.performImageRecognition(image)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func performImageRecognition(_ image: UIImage) {
        let scaledImage = image.scaledImage(1000)
        contentView.startActivityIndicator()
        equationRecognizer.recognize(scaledImage ?? image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let latexEquations):
                    self.equations = latexEquations
                    self.contentView.reloadTable()
                    
                    if latexEquations.isEmpty {
                        let alert = AlertBuilder(title: "No text recognized")
                            .addOkButton()
                            .build()
                        self.present(alert, animated: true)
                    }
                case .failure(let error):
                    let alert = AlertBuilder(title: error.readableDescription)
                        .addOkButton()
                        .build()
                    self.present(alert, animated: true)
                }
                self.contentView.stopActivityIndicator()
            }
        }
    }
}



// MARK: - RecognitionContentViewDataSource

extension RecognitionViewController: RecognitionContentViewDataSource {
    func recognizedEquationsCount(for view: RecognitionContentView) -> Int {
        return equations.count
    }
    
    func recognizedEquation(for view: RecognitionContentView, at index: Int)
        -> String {
            return equations[index].latex
    }
}


// MARK: - RecognitionContentViewDelegate

extension RecognitionViewController: RecognitionContentViewDelegate {
    func recognizedEquationContentView(
        _ view: RecognitionContentView, didSelectEquationAt index: Int) {
        let equation = equations[index]
        let points = transformator.getPoints(from: equation)
        do {
            let graph = Graph(points: points)
            try self.arView.build(graph)
        } catch let error {
            let alert = AlertBuilder(
                title: (error as? PlotGeometryCreator.GrapghBuildingError)?
                    .localizedDescription ?? error.localizedDescription)
                .addOkButton()
                .build()
            self.present(alert, animated: true)
        }
    }
    
    func recognizedEquationContentView(_ view: RecognitionContentView, sliderValueChanges value: Float) {
        let equation = Equation(latex: "", function: { (x: Float, y: Float) -> Float in sin(sin(sin(x)))*sin(sin(sin(y*value))) })
        let points = transformator.getPoints(from: equation)
        do {
            let graph = Graph(points: points)
            try self.arView.build(graph)
        } catch let error {
            let alert = AlertBuilder(
                title: (error as? PlotGeometryCreator.GrapghBuildingError)?
                    .localizedDescription ?? error.localizedDescription)
                .addOkButton()
                .build()
            self.present(alert, animated: true)
        }
    }
}
