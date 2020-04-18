//
//  MainCoordinator.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

class BaseCoordinator: NSObject, Coordinator, Router {
    
    
    // MARK: - Properties
    
    var presenter: UINavigationVC? { navigationVC }
    
    
    // MARK: - Properties
    
    var children: [Coordinator] = []
    var navigationVC: UINavigationVC
    
    
    // MARK: - Initialization
    
    init(navigationVC: UINavigationVC = UINavigationVC()) {
        navigationVC.navigationBar.isHidden = true
        self.navigationVC = navigationVC
    }
    
    func start() {
        navigationVC.delegate = self
    }
    
    func start(with option: DeepLinkOption?) {
        navigationVC.delegate = self
    }
}


extension BaseCoordinator: UINavigationControllerDelegate {}
