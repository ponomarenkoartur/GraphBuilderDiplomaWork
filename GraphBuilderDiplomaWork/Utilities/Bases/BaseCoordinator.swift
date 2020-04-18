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
    
    var presenter: UINavVC? { navVC }
    
    
    // MARK: - Properties
    
    var children: [Coordinator] = []
    var navVC: UINavVC
    
    
    // MARK: - Initialization
    
    init(navigationVC: UINavVC = UINavVC()) {
        navigationVC.navigationBar.isHidden = true
        self.navVC = navigationVC
    }
    
    func start() {
        navVC.delegate = self
    }
    
    func start(with option: DeepLinkOption?) {
        navVC.delegate = self
    }
}


extension BaseCoordinator: UINavigationControllerDelegate {}
