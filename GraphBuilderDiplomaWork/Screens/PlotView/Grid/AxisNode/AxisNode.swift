//
//  AxisNode.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 14.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import SceneKit
import RxSwift


class AxisNode: BaseSCNNode {
    
    
    // MARK: - Properties
    
    fileprivate var valuesBoundsSubject =
        BehaviorSubject<ValuesBounds>(value: -1...1)
    var valuesBounds: ValuesBounds {
        get { try! valuesBoundsSubject.value() }
        set { valuesBoundsSubject.onNext(newValue) }
    }
    var valuesDelta: Double {
        get {
            Self.getValuesDelta(from: valuesBounds)
        }
    }
    var midValue: Double {
        get {
            Self.getValuesDelta(from: valuesBounds)
        }
    }
    
    fileprivate var axisScaleSubject = BehaviorSubject<Float>(value: 1)
    var axisScale: Float {
        get { try! axisScaleSubject.value() }
        set { axisScaleSubject.onNext(newValue) }
    }
    
    
    // MARK: Nodes
    
    let cylinder: SCNNode
    let coneArrow: SCNNode
    let scaleMarkersControls: [ScaleMarkerControl]
    var scaleMarkers: [SCNNode] {
        scaleMarkersControls.map { $0.node }
    }
    
    private var cylinderGeometry: SCNCylinder {
        cylinder.geometry as! SCNCylinder
    }
    private var coneGeometry: SCNCone {
        coneArrow.geometry as! SCNCone
    }
    
    
    // MARK: - Initialization
    
    init(cylinder: SCNNode, coneArrow: SCNNode,
         scaleMarkers: [SCNNode]) {
        self.cylinder = cylinder
        self.coneArrow = coneArrow
        self.scaleMarkersControls = scaleMarkers
            .map { ScaleMarkerControl(node: $0) }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Methods
    
    override func setupBinding() {
        super.setupBinding()
        Observable.combineLatest(valuesBoundsSubject, axisScaleSubject)
            .subscribe(onNext: { valuesBounds, axisScale in
                let markersValues = Self.getMarkersPositions(for: valuesBounds)
                let realPositions = markersValues.map {
                    convert($0, from: valuesBounds, to: -1...1)
                }
                for (i, position) in realPositions.enumerated() {
                    let marker = self.scaleMarkers[safe: i]
                    let markerControl = self.scaleMarkersControls[safe: i]
                    markerControl?.setTextValue(markersValues[i])
                    marker?.isHidden = false
                    marker?.position.x = Float(position) * self.cylinder.scale.y
                    marker?.scale = SCNVector3(axisScale)
                }
                self.scaleMarkers[safe: realPositions.count...]?.forEach {
                    $0.isHidden = true
                }
                
                self.cylinder.scale = SCNVector3(axisScale)
                self.coneArrow.scale = SCNVector3(axisScale)
                self.coneArrow.position.x =
                    Float(self.cylinderGeometry.height) * axisScale / 2
            })
            .disposed(by: bag)
    }
    
    
    // MARK: - API Methods
    
    func setScale(_ scale: Float, animationDuration: TimeInterval = 0) {
        axisScale = scale
    }
    
    func setBounds(_ bounds: ValuesBounds, animationDuration: TimeInterval = 0) {
        valuesBounds = bounds
    }
    
    func setTextNodesConstraints(_ constraints: [SCNConstraint]) {
        scaleMarkersControls.forEach {
            $0.textNode.constraints = constraints
        }
    }
    
    
    // MARK: - Static Methods
    
    fileprivate static func getValuesDelta(from valuesBounds: ValuesBounds)
        -> Double {
            valuesBounds.upperBound - valuesBounds.lowerBound
    }
    
    fileprivate static func getMidValue(from valuesBounds: ValuesBounds)
        -> Double {
            (valuesBounds.upperBound + valuesBounds.lowerBound) / 2
    }
    
    private static func getGridStep(for length: Double) -> Double {
        var step: Double = 1
        var stepCount: Int { Int(length / step) }

        let multiplier = length > 1 ? 10 : 0.1
        while !(1..<10).contains(stepCount) {
            step *= multiplier
        }

        let submultipliers: [Double] = [2, 2.5, 2]
        for submultiplier in submultipliers {
            if (4...10).contains(stepCount) {
                break
            }
            step /= submultiplier
        }

        return step
    }
    
    private static func getMarkersPositions(for bounds: ValuesBounds) -> [Double] {
        let delta = getValuesDelta(from: bounds)
        let step = getGridStep(for: delta)
        
        var position = Double(Int(bounds.lowerBound / step)) * step
        var positions: [Double] = []
        
        while position < bounds.upperBound {
            positions.append(position.rounded(toPlaces: step.digitsCountAfterDot()))
            position += step
        }
        
        return positions
    }

}


// MARK: - Rx

extension Reactive where Base == AxisNode {
    var valuesBounds: Observable<ValuesBounds> {
        base.valuesBoundsSubject.asObservable()
    }
    var valuesDelta: Observable<Double> {
        valuesBounds.map { AxisNode.getValuesDelta(from: $0) }
    }
    var axisScale: Observable<Float> {
        base.axisScaleSubject.asObservable()
    }
}
