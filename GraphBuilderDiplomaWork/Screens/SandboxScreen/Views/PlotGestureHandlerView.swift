//
//  PlotGestureHandlerView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 13.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SceneKit
import RxSwift


class PlotGestureHandlerView: BaseView {
    
    
    // MARK: - Enums
    
    enum PanMovingMode {
        /// Pan gesture moves plot in absolute directions regardless of its euler angles
        case absolute
        /// Pan gesture moves plot in relative directions depending of its euler angles
        /// That means that plot will be moved in directions of its axises
        case relative
    }
    
    
    // MARK: - Properties
    
    private(set) var scenes: [PlotPresenter] = []
    private(set) var panMovingModes: [PanMovingMode] = []
    var shouldHandleAxis: (x: Bool, y: Bool, z: Bool) = (true, true, true)
    
    fileprivate var manipulationModeSubject = BehaviorSubject(value: PlotManipulationMode.local)
    var manipulationMode: PlotManipulationMode {
        get { try! manipulationModeSubject.value() }
        set { manipulationModeSubject.onNext(newValue) }
    }
    
    enum DragRotateMode {
        case drag, rotate
    }
    fileprivate var dragRotateModeSubject =
        BehaviorSubject(value: DragRotateMode.drag)
    var dragRotateMode: DragRotateMode {
        get { try! dragRotateModeSubject.value() }
        set { dragRotateModeSubject.onNext(newValue) }
    }
    
    
    // MARK: Callbacks
    
    var didTap: () -> () = {}
    
    
    // MARK: Gesture properties
    
    /// Scale of scene before pinch gesture began
    private var initialScales: [SCNVector3]?
    /// Grid bounds before pinch or pan gesture began
    private var initialGridBoundsList: [GridBounds]?
    /// Plot position before pan gesture began
    private var initialPositions: [SCNVector3]?
    
    /// Relative positions of plots before pan gesture began
    private var initialRelativeAxisesPositions: [SCNVector3]?
    /// Plot rotations before rotation gesture began
    private var initialAxisesRotation: [SCNVector3]?
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .clear
    }
    
    
    // MARK: - Gestures
    
    
    override func setupGesturesRecognizers() {
        super.setupGesturesRecognizers()

        rx.pinchGesture()
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { gr in self.handlePinch(gr) })
            .disposed(by: bag)

        rx.panGesture()
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { self.handlePan($0) })
            .disposed(by: bag)
        
        rx.tapGesture()
            .subscribe(onNext: { _ in self.didTap() })
            .disposed(by: bag)
    }
    
    private func handlePan(_ gr: UIPanGestureRecognizer) {
        switch dragRotateMode {
        case .drag:
            handlePanToMove(gr)
        case .rotate:
            handlePanToRotate(gr)
        }
    }
    
    private func handlePanToMove(_ gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            initialGridBoundsList = scenes.map { $0.gridBounds }
            initialPositions = scenes.map { $0.plotsAndGridWrapperPosition }
            initialRelativeAxisesPositions = scenes.map { $0.relativeAxisesPosition }
        case .changed:
            guard let initialGridBoundsList = initialGridBoundsList,
                let initialPositions = initialPositions,
                let initialRelativeAxisesPositions = initialRelativeAxisesPositions else {
                return
            }
            
            switch manipulationMode {
            case .world:
                let k: Float = 1 / 100
                
                let xOffset = Float(gr.translation(in: self).x) * k
                let yOffset = Float(gr.translation(in: self).y) * k
                let sumOffset = (xOffset - yOffset) / 2
                
                var targetPositions = initialPositions
                var targetRelativeAxisesPositions = initialRelativeAxisesPositions
                
                //
                //  Condition (x, y, z) |      x      |      y      |      z      |
                //  ____________________|_____________|_____________|_____________|
                //           111        |   xOffset   |   yOffset   |      -      |
                //           110        |   xOffset   |   yOffset   |      -      |
                //           101        |   xOffset   |      -      |   yOffset   |
                //           100        | (x+y)Offset |      -      |      -      |
                //           011        |      -      |   yOffset   |   xOffset   |
                //           010        |      -      | (x+y)Offset |      -      |
                //           001        |      -      |      -      | (x+y)Offset |
                //           000        |      -      |      -      |      -      |
                //
                for (i, _) in targetPositions.enumerated() {
                    switch shouldHandleAxis {
                    case (x: true, y: true, z: _):
                        targetPositions[i].x += xOffset
                        targetPositions[i].y += -yOffset
                        
                        targetRelativeAxisesPositions[i].x += xOffset
                        targetRelativeAxisesPositions[i].y += -yOffset
                    case (x: true, y: false, z: true):
                        targetPositions[i].x += xOffset
                        targetPositions[i].z += -yOffset
                        
                        targetRelativeAxisesPositions[i].x += xOffset
                        targetRelativeAxisesPositions[i].z += -yOffset
                    case (x: true, y: false, z: false):
                        targetPositions[i].x += sumOffset
                        targetRelativeAxisesPositions[i].x += sumOffset
                    case (x: false, y: true, z: true):
                        targetPositions[i].y += -yOffset
                        targetPositions[i].z += xOffset
                        
                        targetRelativeAxisesPositions[i].y += -yOffset
                        targetRelativeAxisesPositions[i].z += xOffset
                    case (x: false, y: true, z: false):
                        targetPositions[i].y += sumOffset
                        targetRelativeAxisesPositions[i].y += sumOffset
                    case (x: false, y: false, z: true):
                        targetPositions[i].z += sumOffset
                        targetRelativeAxisesPositions[i].z += sumOffset
                    case (x: false, y: false, z: false):
                        break
                    }
                    
                    switch panMovingModes[i] {
                    case .absolute:
                        scenes[i].setRootPosition(targetPositions[i])
                    case .relative:
                        scenes[i].setRelativeAxisesPosition(
                            targetRelativeAxisesPositions[i])
                    }
                }
            case .local:
                let k: Double = 1 / 200
                
                let xOffset = Double(gr.translation(in: self).x) * k
                let yOffset = Double(gr.translation(in: self).y) * k
                
                var targetBoundsList = initialGridBoundsList
                
                //
                //  Condition (x, y, z) |      x      |      y      |      z      |
                //  ____________________|_____________|_____________|_____________|
                //           111        |   xOffset   |   yOffset   |      -      | v
                //           110        |   xOffset   |   yOffset   |      -      | v
                //           101        |   xOffset   |      -      |   yOffset   | v
                //           100        | (x+y)Offset |      -      |      -      | v
                //           011        |      -      |   yOffset   |   xOffset   | v
                //           010        |      -      | (x+y)Offset |      -      | v
                //           001        |      -      |      -      | (x+y)Offset | v
                //           000        |      -      |      -      |      -      |
                //
                for (i, _) in targetBoundsList.enumerated() {
                    switch shouldHandleAxis {
                    case (x: true, y: true, z: _):
                        targetBoundsList[i].x +=
                            -xOffset * targetBoundsList[i].x.absDelta
                        targetBoundsList[i].y +=
                            yOffset * targetBoundsList[i].y.absDelta
                    case (x: true, y: false, z: true):
                        targetBoundsList[i].x +=
                            -xOffset * targetBoundsList[i].x.absDelta
                        targetBoundsList[i].z +=
                            yOffset * targetBoundsList[i].z.absDelta
                    case (x: true, y: false, z: false):
                        targetBoundsList[i].x += (-xOffset + yOffset) / 2 *
                            targetBoundsList[i].x.absDelta
                    case (x: false, y: true, z: true):
                        targetBoundsList[i].y +=
                            yOffset * targetBoundsList[i].y.absDelta
                        targetBoundsList[i].z +=
                            -xOffset * targetBoundsList[i].z.absDelta
                    case (x: false, y: true, z: false):
                        targetBoundsList[i].y += (-xOffset + yOffset) / 2 *
                            targetBoundsList[i].y.absDelta
                    case (x: false, y: false, z: true):
                        targetBoundsList[i].z += (-xOffset + yOffset) / 2 *
                            targetBoundsList[i].z.absDelta
                    case (x: false, y: false, z: false):
                        break
                    }
                }
                setBoundsList(targetBoundsList)
            }
        case .ended:
            initialGridBoundsList = nil
            initialPositions = nil
        default:
            break
        }
    }
    
    private func handlePanToRotate(_ gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            initialAxisesRotation = scenes.map { $0.axisesRotationAngles }
        case .changed:
            guard let initialAxisesRotation = initialAxisesRotation else {
                return
            }
            let k: Float = 100
            let rotationAngleX = Float(gr.translation(in: self).y) / k
            let rotationAngleY = Float(gr.translation(in: self).x) / k
            let targetAxisesRotation = initialAxisesRotation.map {
                SCNVector3($0.x + rotationAngleX, $0.y + rotationAngleY, $0.z)
            }
            setAxisesRotationList(targetAxisesRotation)
        default:
            initialAxisesRotation = nil
        }
    }
    
    private func handlePinch(_ gr: UIPinchGestureRecognizer) {
        switch gr.state {
        case .began:
            initialScales = scenes.map { $0.nodeScale }
            initialGridBoundsList = scenes.map { $0.gridBounds }
        case .changed:
            guard let initialScales = initialScales,
                let initialGridBoundsList = initialGridBoundsList else {
                return
            }
            
            switch manipulationMode {
            case .world:
                setScales(initialScales.map { $0 * Float(gr.scale) })
            case .local:
                setBoundsList(
                    initialGridBoundsList.map { $0 / Double(gr.scale) }
                )
            }
        default:
            initialScales = nil
            initialGridBoundsList = nil
        }
    }
    
    private func handleRotation(_ gr: UIRotationGestureRecognizer) {
        switch gr.state {
        case .began:
            initialAxisesRotation = scenes.map { $0.axisesRotationAngles }
        case .changed:
            guard let initialAxisesRotation = initialAxisesRotation else {
                return
            }
            let k: Float = 6
            let rotationAngle = Float(gr.rotation.radiansToDegrees) / k
            let targetAxisesRotation = initialAxisesRotation
                .map { SCNVector3($0.x, $0.y + rotationAngle, $0.z) }
            setAxisesRotationList(targetAxisesRotation)
        default:
            initialAxisesRotation = nil
        }
    }
    
    
    // MARK: - API Methods
    
    func switchManipulationMode() {
        switch manipulationMode {
        case .local:
            manipulationMode = .world
        case .world:
            manipulationMode = .local
        }
    }
    
    func switchDragRotateMode() {
        switch dragRotateMode {
        case .drag:
            dragRotateMode = .rotate
        case .rotate:
            dragRotateMode = .drag
        }
    }
    
    func addScene(_ sceneToAdd: PlotScene, panMovingMode: PanMovingMode) {
        scenes.append(sceneToAdd)
        panMovingModes.append(panMovingMode)
    }
    
    
    
    
    // MARK: - Private Methods
    
    private func setBoundsList(_ targetBoundsList: [GridBounds]) {
        scenes.combined(with: targetBoundsList).forEach {
            scene, targetBounds in
            scene.setBounds(
                x: shouldHandleAxis.x ? targetBounds.x : nil,
                y: shouldHandleAxis.y ? targetBounds.y : nil,
                z: shouldHandleAxis.z ? targetBounds.z : nil)
        }
    }
    
    private func setScales(_ targetScales: [SCNVector3]) {
        scenes.combined(with: targetScales).forEach {
            scene, targetScale in
            scene.scaleNode(
                x: shouldHandleAxis.x ? targetScale.x : nil,
                y: shouldHandleAxis.y ? targetScale.y : nil,
                z: shouldHandleAxis.z ? targetScale.z : nil,
                animationDuration: 0)
        }
    }
    
    private func setPositions(_ targetPositions: [SCNVector3]) {
        scenes.combined(with: targetPositions).forEach {
            scene, targetPosition in
            scene.setRootPosition(targetPosition)
        }
    }
    
    private func setRelativeAxisesPositions(_ targetPositions: [SCNVector3]) {
        scenes.combined(with: targetPositions).forEach {
            scene, targetPosition in
            scene.setRelativeAxisesPosition(targetPosition)
        }
    }
    
    private func setAxisesRotationList(_ rotationsList: [SCNVector3]) {
        scenes.combined(with: rotationsList).forEach {
            scene, axisesRotation in
            scene.setRotation(axisesRotation)
        }
    }
}


// MARK: - Rx

extension Reactive where Base == PlotGestureHandlerView {
    var manipulationMode: Observable<PlotManipulationMode> {
        base.manipulationModeSubject.asObservable()
    }
    var dragRotateMode: Observable<PlotGestureHandlerView.DragRotateMode> {
        base.dragRotateModeSubject.asObservable()
    }
}
