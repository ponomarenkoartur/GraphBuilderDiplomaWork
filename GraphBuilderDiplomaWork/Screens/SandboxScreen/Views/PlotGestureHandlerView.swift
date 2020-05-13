//
//  PlotGestureHandlerView.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 13.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import SceneKit


class PlotGestureHandlerView: BaseView {
    
    
    // MARK: - Properties
    
    var scene: PlotScene!
    var axises: (x: Bool, y: Bool, z: Bool) = (true, true, true)
    
    
    /// Scale of scene before pinch gesture began
    private lazy var sceneInitialScale: SCNVector3 = scene.nodeScale
    
    
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
            .when(.began, .changed, .ended)
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
        case .changed:
            let targetScale = sceneInitialScale * Float(gr.scale)
            scene.scaleNode(x: axises.x ? targetScale.x : nil,
                            y: axises.y ? targetScale.y : nil,
                            z: axises.z ? targetScale.z : nil)
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
    
    
}
