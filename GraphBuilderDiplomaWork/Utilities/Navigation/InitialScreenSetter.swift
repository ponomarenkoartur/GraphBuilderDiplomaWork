//
//  InitialScreenSetter.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit


protocol InitialScreenSetterProtocol {
    associatedtype C: Coordinator
    
    var window: UIWindow { get }
    init(window: UIWindow)
    func setup() -> C
}


class InitialScreenSetter: InitialScreenSetterProtocol {
    
    typealias C = MainCoordinator
    
    // MARK: - Properties
    
    var window: UIWindow
    
    
    // MARK: - Initialization
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    
    // MARK: - Other Methods
    
    func setup() -> MainCoordinator {
        let coordinator = MainCoordinator()
        window.rootViewController = coordinator.navVC
        window.makeKeyAndVisible()
        return coordinator
    }
}
