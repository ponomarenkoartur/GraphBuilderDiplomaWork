//
//  PlotPresenterScene.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 29.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit
import RxSwift


class PlotScene: BaseSCNScene, PlotPresenter {
    
    
    // MARK: - Properties
    
    var plots: [Plot] = []
    private var plotsNodes: [Plot: SCNNode] = [:]
    private var equationTransformator = EquationTransformator()
    private var bag = DisposeBag()
    
    
    // MARK: - Setup Methods
    
    override func setupNodes() {
        super.setupNodes()
        setupGrid()
    }
    
    private func setupGrid() {
        let node = PlotGrid()
        addNodes(node)
    }
    
    
    // MARK: - API Methods
    
    func add(_ plot: Plot) {
        let node = SCNNode()
        
        rootNode.addChildNode(node)
        
        plots.append(plot)
        plotsNodes[plot] = node
        
        plot.rx.title.subscribe(onNext: { node.name = $0 }).disposed(by: bag)
        
        Observable.combineLatest(plot.rx.error, plot.rx.isHidden)
            .subscribe(onNext: { error, isHidden in
                node.isHidden = error != nil || isHidden
            })
            .disposed(by: bag)
        
        var parametersDiposable: Disposable?
        plot.rx.equation
            .subscribe(onNext: { equation in
                self.updateGeometry(with: plot, of: node)
                parametersDiposable?.dispose()
                parametersDiposable = self.observeParameters(plot, node: node)
            })
            .disposed(by: bag)
        
        plot.rx.color.subscribe(onNext: {
            node.geometry?.firstMaterial?.diffuse.contents = $0
        }).disposed(by: bag)
    }
    
    func rebuild(_ plot: Plot, at index: Int) {}
    
    func deletePlot(at index: Int) {
        let plot = plots[index]
        plots.remove(at: index)
        plotsNodes[plot]?.removeFromParentNode()
        plotsNodes[plot] = nil
    }
    
    func deleteAll() {
        plots.enumerated().reversed().forEach { index, _ in
            deletePlot(at: index)
        }
    }
    
    func scaleGrid(x: Float?, y: Float?, z: Float?) {}
    
    func scaleGrid(_ scale: SCNVector3) {}
    
    func scaleNode(x: Float?, y: Float?, z: Float?) {}
    
    func scaleNode(_ scale: SCNVector3) {}
    
    func resetGridScale() {}
    
    func screenshot() -> UIImage { UIImage() }

    
    // MARK: - Private Methods
    
    private func observeParameters(_ plot: Plot, node: SCNNode) -> Disposable {
        Observable.combineLatest(plot.equation.parameters.map { $0.rx.value })
            .subscribe(onNext: { _ in
                self.updateGeometry(with: plot, of: node)
            })
    }
    
    private func updateGeometry(with plot: Plot, of node: SCNNode) {
        do {
            let points = try self.equationTransformator
                .getPoints(from: plot.equation)
            guard let geometry = try? PlotGeometryCreator().build(points)
                else { return }
            geometry.firstMaterial?.lightingModel = .blinn
            geometry.firstMaterial?.isDoubleSided = true
            geometry.firstMaterial?.diffuse.contents = plot.color
            node.geometry = geometry
            node.opacity = 0.7
            plot.error = nil
        } catch let error {
            plot.error = error
        }
    }
}
