//
//  ARPlotView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 15.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import ARKit
import RxSwift


class ARPlotView: BaseARSCNView {
    
    
    // MARK: - Enums
    
    enum State {
        case scanning, positioning, placed
    }
    
    
    // MARK: - Constants
    
    private let totalFrameCountToStart = 25
    
    
    // MARK: - Properties
    
    var plotScene: PlotScene { scene as! PlotScene }
    
    override var scene: SCNScene {
        didSet {
            if let _ = scene as? PlotScene {
                plotScene.cameraNode = pointOfView!
            }
        }
    }
    
    private let stateSubject = BehaviorSubject(value: State.scanning)
    var state: State {
        get { try! stateSubject.value() }
        set { stateSubject.onNext(newValue) }
    }
    
    var scanProgressObservable: Observable<Int> {
        frameCountSubject.map { self.getScanProgress(fromFrameCount: $0) }
    }
    var scanProgress: Int {
        getScanProgress(fromFrameCount: frameCount)
    }
    
    private let frameCountSubject = BehaviorSubject(value: 0)
    var frameCount: Int {
        get { try! frameCountSubject.value() }
        set { frameCountSubject.onNext(newValue) }
    }

    
    // MARK: Views
    
    private lazy var scanFloorView: ScanFloorView = {
        let view = ScanFloorView()
        view.isHidden = true
        return view
    }()
    
    
    // MARK: - Setup Methods
    
    override func setupScene() {
        super.setupScene()
        autoenablesDefaultLighting = true
    }
    
    override func setupDelegates() {
        super.setupDelegates()
        session.delegate = self
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews(scanFloorView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        scanFloorView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    
    override func setupBinding() {
        super.setupBinding()
        scanProgressObservable
            .subscribe(onNext: { scanProgress in
                if scanProgress == 100, self.state == .scanning {
                    self.state = .positioning
                }
                DispatchQueue.main.async {
                    self.scanFloorView.setProgress(scanProgress)
                }
            })
            .disposed(by: bag)
        stateSubject
            .subscribe(onNext: { state in
                DispatchQueue.main.async {
                    self.scanFloorView.isHidden = state != .scanning
                    self.plotScene.rootWrapperNode.isHidden = state == .scanning
                }
            })
            .disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func startOrResetScan() {
        state = .scanning
        frameCount = 0
    }
    
    func placeNode() {
        guard state == .positioning else { return }
        state = .placed
    }
    
    func run() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        session.run(configuration)
    }
    
    func pause() {
        session.pause()
    }
    
    // MARK: - Private Methods
    
    private func placeStatueNodeAtScreenCenterHitTest() {
        let rootNode = plotScene.rootWrapperNode

        let hitPoint = CGPoint(x: UIScreen.main.bounds.width / 2,
                               y: UIScreen.main.bounds.height / 2)
        
        if let hitTestResult =
            hitTest(hitPoint, types: .estimatedHorizontalPlane).first ??
            hitTest(hitPoint, types: .existingPlaneUsingExtent).first ??
            hitTest(hitPoint, types: .featurePoint).first {
            rootNode.position = SCNVector3(matrix: hitTestResult.worldTransform)
        }
    }
    
    private func rotateBoothNodeToUserCamera() {
        guard let camera =  session.currentFrame?.camera else { return }
        let rootNode = plotScene.rootWrapperNode
        
        let cameraPosition = SCNVector3(matrix: camera.transform)
        rootNode.look(
            at: cameraPosition.modifying(.y, to: rootNode.worldPosition.y),
            up: SCNNode.localUp, localFront: -SCNNode.localFront)
    }
    
    private func getScanProgress(fromFrameCount frameCount: Int) -> Int {
        min(100, Int(Double(frameCount) / Double(totalFrameCountToStart)))
    }
}


// MARK: - ARSCNViewDelegate

extension ARPlotView: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if anchors.contains(where: { $0.isPlane }), state == .scanning {
            state = .positioning
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frameCount += 1
        if case .positioning = state {
            placeStatueNodeAtScreenCenterHitTest()
            rotateBoothNodeToUserCamera()
        }
    }
}
