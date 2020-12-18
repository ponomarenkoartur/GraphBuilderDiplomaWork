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
        self.navVC = navigationVC
        super.init()
        navVC.delegate = self
        navVC.navigationBar.tintColor = Color.turquoise()
    }
    
    func start() {}
}


extension BaseCoordinator: UINavigationControllerDelegate {}
