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
    
    private var gridBoundsSubject = BehaviorSubject(
        value: GridBounds(x: -1...1, y: -1...1, z: -1...1))
    var gridBounds: GridBounds {
        get { try! gridBoundsSubject.value() }
        set { gridBoundsSubject.onNext(newValue) }
    }
    var plotsAndGridWrapperPosition: SCNVector3 {
        plotsAndGridWrapper.position
    }
    
    private var axisesRotationAnglesSubject =
        BehaviorSubject(value: SCNVector3(0, 0, 0))
    var axisesRotationAngles: SCNVector3 {
        get { try! axisesRotationAnglesSubject.value() }
        set { axisesRotationAnglesSubject.onNext(newValue) }
    }
    
    
    private var plotsNodes: [Plot: SCNNode] = [:]
    private var equationTransformator = EquationTransformator()
    
    /// Node that contains all nodes except camera
    private lazy var plotsAndGridWrapper = SCNNode()
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
    lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.name = "Camera"
        node.position.z = 3
        node.camera = camera
        return node
    }()
    private lazy var camera: SCNCamera = {
        let camera = SCNCamera()
        camera.zNear = 0
        camera.orthographicScale = 2.5
        camera.usesOrthographicProjection = true
        return camera
    }()
    
    
    
    // MARK: - Setup Methods
    
    override func setupNodes() {
        super.setupNodes()
        rootNode.addNodes(plotsAndGridWrapper, cameraNode)
        plotsAndGridWrapper.addNodes(gridNode, plotWrapperNode)
//        setupTextConstraints()
    }
    
    override func setupBinding() {
        super.setupBinding()
        gridBoundsSubject
            .subscribe(onNext: { gridBounds in
                self.gridNode.setBounds(gridBounds)
                self.equationTransformator.setBounds(gridBounds)
                self.plotsNodes.forEach { plot, node in
                    self.updateGeometry(with: plot, of: node)
                    
                    node.position.x = -Float(gridBounds.x.mid) * Float(defaultBoxSize / gridBounds.x.delta)
                    node.position.y = -Float(gridBounds.y.mid) * Float(defaultBoxSize / gridBounds.y.delta)
                    node.position.z = -Float(gridBounds.z.mid) * Float(defaultBoxSize / gridBounds.z.delta)
                    
                    node.scale.x = Float(defaultBoxSize / gridBounds.x.delta)
                    node.scale.y = Float(defaultBoxSize / gridBounds.y.delta)
                    node.scale.z = Float(defaultBoxSize / gridBounds.z.delta)
                }
            })
            .disposed(by: bag)
        
        axisesRotationAnglesSubject
            .subscribe(onNext: {
                self.plotsAndGridWrapper.eulerAngles = $0
            })
            .disposed(by: bag)
    }
    
    private func setupTextConstraints() {
        let constraint = SCNLookAtConstraint(target: cameraNode)
        constraint.localFront = SCNVector3(0, 0, 1)
        gridNode.setTextNodesConstraints([constraint])
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
    
    func setBounds(x: ValuesBounds? = nil, y: ValuesBounds? = nil,
                   z: ValuesBounds? = nil) {
        self.gridBounds = GridBounds(x: x ?? gridBounds.x,
                                     y: y ?? gridBounds.y,
                                     z: z ?? gridBounds.z)
    }
    
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
        gridNode.scale(targetScale, animationDuration: animationDuration)
    }
    
    
    func screenshot() -> UIImage { UIImage() }
    
    func setRootPosition(x: Float?, y: Float?, z: Float?) {
        plotsAndGridWrapper.position.x = x ?? plotsAndGridWrapper.position.x
        plotsAndGridWrapper.position.y = y ?? plotsAndGridWrapper.position.y
        plotsAndGridWrapper.position.z = z ?? plotsAndGridWrapper.position.z
    }
    
    func setRotation(x: Float?, y: Float?, z: Float?) {
        axisesRotationAngles = SCNVector3(x ?? axisesRotationAngles.x,
                                          y ?? axisesRotationAngles.y,
                                          z ?? axisesRotationAngles.z)
    }
    
    func resetNodeScale(animationDuration: TimeInterval = 0) {
        scaleNode(1)
    }
    
    func resetRotation(animationDuration: TimeInterval = 0) {
        setRotation(x: 0, y: 0, z: 0)
    }
    
    func resetRootPosition(animationDuration: TimeInterval = 0) {
        setRootPosition(x: 0, y: 0, z: 0)
    }
    
    func resetBounds(animationDuration: TimeInterval = 0) {
        setBounds(-1...1)
    }

    
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
