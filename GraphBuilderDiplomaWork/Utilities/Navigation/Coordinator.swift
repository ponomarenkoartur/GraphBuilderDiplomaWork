//
//  Coordinator.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit


protocol Coordinator: class {
    var children: [Coordinator] { get set }
    func start()
    func addDependency(_ coordinator: Coordinator)
    func removeDependency(_ coordinator: Coordinator)
    func removeAllDependencies()
}


extension Coordinator {
    func addDependency(_ coordinator: Coordinator) {
        children.append(coordinator)
    }
    func removeDependency(_ coordinator: Coordinator) {
        children.removeAll(where: { $0 === coordinator })
    }
    func removeAllDependencies() {
        children.removeAll()
    }
}
