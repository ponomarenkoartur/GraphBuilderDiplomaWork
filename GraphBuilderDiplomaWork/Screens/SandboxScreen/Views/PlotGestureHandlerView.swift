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
    
    
    // MARK: - Properties
    
    private(set) var scenes: [PlotPresenter] = []
    var shouldHandleAxis: (x: Bool, y: Bool, z: Bool) = (true, true, true)
    
    fileprivate var manipulationModeSubject = BehaviorSubject(value: PlotManipulationMode.local)
    var manipulationMode: PlotManipulationMode {
        get { try! manipulationModeSubject.value() }
        set { manipulationModeSubject.onNext(newValue) }
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
    /// Plot rotations before rotation gesture began
    private var initialAxisesRotation: [SCNVector3]?
    
    
    private var isThreeFingersGestureOn = false
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .clear
    }
    
    
    // MARK: - Gestures
    
    
    override func setupGesturesRecognizers() {
        super.setupGesturesRecognizers()

        rx.panGesture(configuration: { (gr, _) in
                gr.minimumNumberOfTouches = 3
                gr.maximumNumberOfTouches = 3
            })
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { self.handlePan($0) })
            .disposed(by: bag)

        rx.pinchGesture()
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { gr in self.handlePinch(gr) })
            .disposed(by: bag)

        rx.panGesture(configuration: { gr, _ in gr.maximumNumberOfTouches = 1 })
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { self.handlePan($0) })
            .disposed(by: bag)
        
        rx.tapGesture()
            .subscribe(onNext: { _ in self.didTap() })
            .disposed(by: bag)
    }
    
    private func handlePan(_ gr: UIPanGestureRecognizer) {
        if gr.numberOfTouches == 1 {
            handlePanToMove(gr)
        } else {
            handlePanToRotate(gr)
        }
    }
    
    private func handlePanToMove(_ gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            initialGridBoundsList = scenes.map { $0.gridBounds }
            initialPositions = scenes.map { $0.plotsAndGridWrapperPosition }
        case .changed:
            guard let initialGridBoundsList = initialGridBoundsList,
                let initialPositions = initialPositions else {
                return
            }
            
            switch manipulationMode {
            case .world:
                let k: Float = 1 / 100
                
                let xOffset = Float(gr.translation(in: self).x) * k
                let yOffset = Float(gr.translation(in: self).y) * k
                
                var targetPositions = initialPositions
                
                //
                //  Condition (x, y, z) |    x    |    y    |    z    |
                //  ____________________|_________|_________|_________|
                //           111        | xOffset | yOffset |    -    |
                //           110        | xOffset | yOffset |    -    |
                //           101        | xOffset |    -    | yOffset |
                //           100        | xOffset |    -    |    -    |
                //           011        |    -    | yOffset | xOffset |
                //           010        |    -    | yOffset |    -    |
                //           001        |    -    |    -    | yOffset |
                //           000        |    -    |    -    |    -    |
                //
                for (i, _) in targetPositions.enumerated() {
                    if shouldHandleAxis.x {
                        targetPositions[i].x += xOffset
                    }
                    if shouldHandleAxis.y {
                        targetPositions[i].y += -yOffset
                    }
                    if shouldHandleAxis.z && !shouldHandleAxis.x {
                        targetPositions[i].z += (-xOffset + yOffset) / 2
                    } else if shouldHandleAxis.z && !shouldHandleAxis.y {
                        targetPositions[i].z += -xOffset
                    }
                }
                setPositions(targetPositions)
            case .local:
                let k: Double = 1 / 200
                
                let xOffset = Double(gr.translation(in: self).x) * k
                let yOffset = Double(gr.translation(in: self).y) * k
                
                var targetBoundsList = initialGridBoundsList
                
                //
                //  Condition (x, y, z) |    x    |    y    |    z    |
                //  ____________________|_________|_________|_________|
                //           111        | xOffset | yOffset |    -    |
                //           110        | xOffset | yOffset |    -    |
                //           101        | xOffset |    -    | yOffset |
                //           100        | xOffset |    -    |    -    |
                //           011        |    -    | yOffset | xOffset |
                //           010        |    -    | yOffset |    -    |
                //           001        |    -    |    -    | yOffset |
                //           000        |    -    |    -    |    -    |
                //
                for (i, _) in targetBoundsList.enumerated() {
                    if shouldHandleAxis.x {
                        targetBoundsList[i].x +=
                            -xOffset * targetBoundsList[i].x.absDelta
                    }
                    if shouldHandleAxis.y {
                        targetBoundsList[i].y +=
                            yOffset * targetBoundsList[i].y.absDelta
                    }
                    if shouldHandleAxis.z && !shouldHandleAxis.x {
                        targetBoundsList[i].z += (-xOffset + yOffset) / 2 *
                            targetBoundsList[i].z.absDelta
                    } else if shouldHandleAxis.z && !shouldHandleAxis.y {
                        targetBoundsList[i].z +=
                            -xOffset * targetBoundsList[i].z.absDelta
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
            isThreeFingersGestureOn = true
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
            isThreeFingersGestureOn = false
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
                let initialGridBoundsList = initialGridBoundsList,
                !isThreeFingersGestureOn else {
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
    
    func addScenes(_ scenesToAdd: [PlotScene]) {
        scenes.append(contentsOf: scenesToAdd)
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
            scene.setRootPosition(
                x: shouldHandleAxis.x ? targetPosition.x : nil,
                y: shouldHandleAxis.y ? targetPosition.y : nil,
                z: shouldHandleAxis.z ? targetPosition.z : nil)
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
}
