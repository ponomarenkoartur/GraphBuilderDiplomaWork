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
    var nodeScale: SCNVector3 { plotWrapperNode.scale }
    
    private var plotsNodes: [Plot: SCNNode] = [:]
    private var equationTransformator = EquationTransformator()
    private var bag = DisposeBag()
    
    private let plotWrapperNode: SCNNode = {
        let node = SCNNode()
        node.name = "plotWrapperNode"
        return node
    }()
    private let gridNode: PlotGrid = {
        let node = PlotGrid()
        node.name = "gridNode"
        return node
    }()
    private lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.name = "Camera"
        node.position.z = 2
        node.camera = camera
        return node
    }()
    private let camera = SCNCamera()
    
    
    
    // MARK: - Setup Methods
    
    override func setupNodes() {
        super.setupNodes()
        rootNode.addNodes(plotWrapperNode, cameraNode)
        plotWrapperNode.addNodes(gridNode)
    }
    
    // MARK: - API Methods
    
    func add(_ plot: Plot) {
        let node = SCNNode()
        node.name = plot.equation.latex
        
        plotWrapperNode.addChildNode(node)
        
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
    
    func deletePlot(at index: Int) {
        let plot = plots[index]
        plots.remove(at: index)
        plotsNodes[plot]?.removeFromParentNode()
        plotsNodes[plot] = nil
    }
    
    func scaleGrid(x: Float?, y: Float?, z: Float?) {}
    
    
    func scaleNode(x: Float?, y: Float?, z: Float?,
                   animationDuration: TimeInterval = 0) {
        let targetScale = SCNVector3(x ?? plotWrapperNode.scale.x,
                                     y ?? plotWrapperNode.scale.y,
                                     z ?? plotWrapperNode.scale.z)
        
        if animationDuration == 0 {
            plotWrapperNode.scale = targetScale
        } else {
            let action = SCNAction.scale(to: targetScale,
                                         duration: animationDuration)
            plotWrapperNode.runAction(action)
        }
    }
    
    
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
