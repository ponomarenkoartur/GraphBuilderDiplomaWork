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
    
    private(set) var scenes: [PlotScene] = []
    var shouldHandleAxis: (x: Bool, y: Bool, z: Bool) = (true, true, true)
    
    fileprivate var manipulationModeSubject = BehaviorSubject(value: PlotManipulationMode.local)
    var manipulationMode: PlotManipulationMode {
        get { try! manipulationModeSubject.value() }
        set { manipulationModeSubject.onNext(newValue) }
    }
    
    
    /// Scale of scene before pinch gesture began
    private var initialScales: [SCNVector3] = []
    /// Grid bound before pinch gesture began
    private var initialGridBoundsList: [GridBounds] = []
    
    
    // MARK: - Initialization
    
    
    // MARK: - Setup Methods
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .clear
    }
    
    
    // MARK: - Gestures
    
    
    override func setupGesturesRecognizers() {
        super.setupGesturesRecognizers()
        
        rx.swipeGesture([.down, .left, .right, .up])
            .when(.ended)
            .subscribe(onNext: { self.handleSwipe($0) })
            .disposed(by: bag)
        
        rx.panGesture()
            .when(.began, .ended)
            .subscribe(onNext: { self.handlePan($0) })
            .disposed(by: bag)
        
        rx.panGesture()
            .when(.changed)
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { self.handlePan($0) })
            .disposed(by: bag)
        
        rx.pinchGesture()
            .when(.began, .ended)
            .subscribe(onNext: { self.handlePinch($0) })
            .disposed(by: bag)
        
        rx.pinchGesture()
            .when(.changed)
            .throttle(.milliseconds(40), scheduler: MainScheduler.instance)
            .subscribe(onNext: { self.handlePinch($0) })
            .disposed(by: bag)
        
        rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { self.handleTap($0) })
            .disposed(by: bag)
    }
    
    private func handleTap(_ gr: UITapGestureRecognizer) {
        
    }
    
    private func handleSwipe(_ gr: UISwipeGestureRecognizer) {
        print("Handling swipe. State: \(gr.state).")
    }
    
    private func handlePan(_ gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            initialGridBoundsList = scenes.map { $0.gridBounds }
        case .changed:
            switch manipulationMode {
            case .world:
//                let targetScale = initialScale * Float(gr.scale)
//                scene.scaleNode(x: shouldHandleAxis.x ? targetScale.x : nil,
//                                y: shouldHandleAxis.y ? targetScale.y : nil,
//                                z: shouldHandleAxis.z ? targetScale.z : nil)
                break
            case .local:
                let k: Double = 100
                
                let xOffset = Double(gr.translation(in: self).x) / k
                let yOffset = Double(gr.translation(in: self).y) / k
                
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
                        targetBoundsList[i].x += -xOffset
                    }
                    if shouldHandleAxis.y {
                        targetBoundsList[i].y += yOffset
                    }
                    if shouldHandleAxis.z &&
                        (!shouldHandleAxis.x || !shouldHandleAxis.y) {
                        targetBoundsList[i].z += shouldHandleAxis.y ? xOffset : yOffset
                    }
                }
                setBoundsList(targetBoundsList)
                print()
            }
        case .ended:
            break
        default:
            break
        }
        
    }
    
    private func handlePinch(_ gr: UIPinchGestureRecognizer) {
        print("""
            Handling pinch.
            State: \(gr.state).
            Scale: \(gr.scale).
            Velocity: \(gr.velocity)
            """)
        
        switch gr.state {
        case .began:
            initialScales = scenes.map { $0.nodeScale }
            initialGridBoundsList = scenes.map { $0.gridBounds }
        case .changed:
            switch manipulationMode {
            case .world:
                setScales(initialScales.map { $0 * Float(gr.scale) })
            case .local:
                setBoundsList(
                    initialGridBoundsList.map { $0 / Double(gr.scale) }
                )
            }
        default:
            break
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
    
    func setBoundsList(_ targetBoundsList: [GridBounds]) {
        scenes.combined(targetBoundsList).forEach {
            scene, targetBounds in
            scene.setBounds(
                x: shouldHandleAxis.x ? targetBounds.x : nil,
                y: shouldHandleAxis.y ? targetBounds.y : nil,
                z: shouldHandleAxis.z ? targetBounds.z : nil)
        }
    }
    
    func setScales(_ targetScales: [SCNVector3]) {
        scenes.combined(targetScales).forEach {
            scene, targetScale in
            scene.scaleNode(
                x: shouldHandleAxis.x ? targetScale.x : nil,
                y: shouldHandleAxis.y ? targetScale.y : nil,
                z: shouldHandleAxis.z ? targetScale.z : nil)
        }
    }
    
}


// MARK: - Rx

extension Reactive where Base == PlotGestureHandlerView {
    var manipulationMode: Observable<PlotManipulationMode> {
        base.manipulationModeSubject.asObservable()
    }
}
