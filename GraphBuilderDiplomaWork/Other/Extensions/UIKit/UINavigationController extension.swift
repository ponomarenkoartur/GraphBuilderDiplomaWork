//
//  UINavigationController extension.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// Typealias for `pushViewController(_ viewController: UIViewController, animated: Bool)`
    /// - Parameters:
    ///   - vc: view controller to be pushed
    ///   - animated:
    func push(_ vc: UIVC, animated: Bool = true) {
        pushViewController(vc, animated: animated)
    }
    
    func setPopGestureEnabled(_ isEnabled: Bool = true) {
        interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
}
