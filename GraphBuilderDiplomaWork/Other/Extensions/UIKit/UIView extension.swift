//
//  UIView extension.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit
import SnapKit


// MARK: - Animation

extension UIView {
    func pulsate(duration: Double = 0.1, repeatCount: Float = 1,
                 scale: Double = 1.1) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = repeatCount
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = scale
        self.layer.add(scaleAnimation, forKey: "scale")
    }
}

// MARK: - Appearance

extension UIView {
    func round(_ corners: UIRectCorner = [.allCorners], radius: CGFloat) {
        if corners == [.allCorners] {
            round(radius: radius)
            return
        }
        let path = UIBezierPath(
            roundedRect: bounds, byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    
    private func round(radius: CGFloat = 0.0) {
        layer.cornerRadius = radius
        if layer.shadowColor == nil {
            layer.masksToBounds = radius > 0
        }
    }
    
    func addBorder(color: UIColor? = nil,
                   width: CGFloat = 0.0) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor ?? nil
    }
}


// MARK: - Fabric


extension UIView {
    static func create(_ buildFunc: () -> UIView) -> UIView {
        return buildFunc()
    }
    
    static func createSpacer(size: CGSize) -> UIView {
        createSpacer(w: size.width, h: size.height)
    }
    
    
    /// Create transparent view with 'height' and 'width' constraints
    /// - Parameters:
    ///   - w: width constraint
    ///   - h: height constraint
    ///   - wPriority: priority of width constraint
    ///   - hPriority: priority of height constraint
    static func createSpacer(
        w: CGFloat? = nil, h: CGFloat? = nil,
        wPriority: Double = 1000, hPriority: Double = 1000) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.snp.makeConstraints {
            if let w = w {
                $0.width.equalTo(w).priority(wPriority)
            }
            if let h = h {
                $0.height.equalTo(h).priority(hPriority)
            }
        }
        return view
    }
    
    /// Create transparent view with 'height' and 'width' constraints
    /// - Parameters:
    ///   - widthGreaterThan: width constraint
    ///   - heightGreaterThan: height constraint
    ///   - wPriority: priority of width constraint
    ///   - hPriority: priority of height constraint
    static func createSpacer(
        widthGreaterThan: CGFloat? = nil, heightGreaterThan: CGFloat? = nil,
        wPriority: Double = 1000, hPriority: Double = 1000) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(widthGreaterThan ?? 0)
                .priority(wPriority)
            $0.height.greaterThanOrEqualTo(heightGreaterThan ?? 0)
                .priority(hPriority)
        }
        return view
    }
}


// MARK: - Subviews

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
