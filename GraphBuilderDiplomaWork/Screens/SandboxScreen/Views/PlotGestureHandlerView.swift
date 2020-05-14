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
    
    var scene: PlotScene!
    var shouldHandleAxis: (x: Bool, y: Bool, z: Bool) = (true, true, true)
    
    fileprivate var modeSubject = BehaviorSubject(value: ManipulationMode.bounds)
    var mode: ManipulationMode {
        get { try! modeSubject.value() }
        set { modeSubject.onNext(newValue) }
    }
    
    
    /// Scale of scene before pinch gesture began
    private lazy var sceneInitialScale: SCNVector3 = scene.nodeScale
    /// Grid bound before pinch gesture began
    private lazy var initialGridBound: GridBounds = scene.gridBounds
    
    
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
            .when(.began, .changed, .ended)
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
        print("""
            Handling pan.
                State: \(gr.state).
                Translation: \(gr.translation(in: self)).
                Velocity: \(gr.velocity(in: self))
            """)
        
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
            sceneInitialScale = scene.nodeScale
            initialGridBound = scene.gridBounds
        case .changed:
            switch mode {
            case .scale:
                let targetScale = sceneInitialScale * Float(gr.scale)
                scene.scaleNode(x: shouldHandleAxis.x ? targetScale.x : nil,
                                y: shouldHandleAxis.y ? targetScale.y : nil,
                                z: shouldHandleAxis.z ? targetScale.z : nil)
            case .bounds:
                let targetBounds = initialGridBound / Double(gr.scale)
                scene.setBounds(x: shouldHandleAxis.x ? targetBounds.x : nil,
                                y: shouldHandleAxis.y ? targetBounds.y : nil,
                                z: shouldHandleAxis.z ? targetBounds.z : nil)
            }
            
        case .ended:
//            let velocity = Double(max(1, min(100, abs(gr.velocity))))
//
//            let animationDuration = GraphBuilderDiplomaWork
//                .convert(abs(Double(gr.velocity)),
//                         from: 0...100,
//                         to: Scale(lower: 0.5, upper: 0.05))
////            velocity = GraphBuilderDiplomaWork
////                .convert(velocity, from: 1...100, to: 1...100)
//
//            var targetScale = sceneInitialScale.x * Float(gr.scale)
//            if gr.velocity < 0 {
//                targetScale /= Float(velocity)
//            } else {
//                targetScale *= Float(velocity)
//            }
//
//            self.scene.scaleNode(targetScale, animationDuration: animationDuration)
            break
        default:
            break
        }
    }
    
    
    // MARK: - API Methods
    
    func switchMode() {
        switch mode {
        case .bounds:
            mode = .scale
        case .scale:
            mode = .bounds
        }
    }
    
}


// MARK: - Rx

extension Reactive where Base == PlotGestureHandlerView {
    var mode: Observable<ManipulationMode> {
        base.modeSubject.asObservable()
    }
}
