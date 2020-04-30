//
//  GraphARSCNView.swift
//  EquationRecognition
//
//  Created by artur_ios on 06.12.2019.
//  Copyright © 2019 Artur. All rights reserved.
//

import ARKit


class GraphARSCNView: ARSCNView {
    
    
    // MARK: - Outlets
    
    private var graphContainerNode = SCNNode()
    private var graphNode: SCNNode?
    
    
    // MARK: Gesture Properties
    
    // BG stands for before gesture
    private var originYAngleBG: Float!
    private var scaleBG: SCNVector3!
    private var cursorPositionBG: SCNVector3!
    
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commontInit()
    }
    
    private func commontInit() {
        scene.rootNode.addChildNode(graphContainerNode)
        registerGestureRecognizers()
    }
    
    
    
    // MARK: - Gestures
    
    private func registerGestureRecognizers() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(
            target: self, action: #selector(handlePinch))
        addGestureRecognizer(pinchGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self, action: #selector(handleLongPress))
        addGestureRecognizer(longPressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(handlePan))
        panGestureRecognizer.require(toFail: longPressGestureRecognizer)
        addGestureRecognizer(panGestureRecognizer)
    }
    
    
    @objc
    private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            scaleBG = graphContainerNode.scale
        case .changed:
            graphContainerNode.scale = scaleBG * Float(recognizer.scale)
        default:
            break
        }
    }
    
    @objc
    private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        let hitPoint = recognizer.location(in: self)
        guard let hitTestResult =
            hitTest(hitPoint, types: .existingPlaneUsingExtent).first ??
                hitTest(hitPoint, types: .existingPlane).first ??
                hitTest(hitPoint, types: .featurePoint).first
            else { return }
        switch recognizer.state {
        case .began:
            cursorPositionBG = SCNVector3(matrix: hitTestResult.worldTransform)
        case .changed:
            graphContainerNode.position =
                SCNVector3(matrix: hitTestResult.worldTransform)
        default:
            break
        }
    }
    
    @objc
    private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let xTransation = recognizer.translation(in: self).x / 1500
        
        switch recognizer.state {
        case .began:
            originYAngleBG = graphContainerNode.eulerAngles.y
        case .changed:
            graphContainerNode.eulerAngles.y =
                originYAngleBG + Float(xTransation.radiansToDegrees)
        default:
            break
        }
    }
    
    
    
    // MARK: - API Methods
    
    func build(_ graph: Graph) throws {
        guard let geometry = try PlotGeometryCreator().build(graph.points)
            else { return }
        graphNode?.removeFromParentNode()
        let node = SCNNode(geometry: geometry)
        graphContainerNode.addChildNode(node)
        graphNode = node
    }
}
