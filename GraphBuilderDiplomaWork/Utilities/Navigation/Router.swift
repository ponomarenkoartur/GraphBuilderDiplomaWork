//
//  Router.swift
//  LimoDad
//
//  Created by artur_ios on 07.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import Foundation


protocol Router {
    var presenter: UINavigationVC? { get }
    func present(_ controller: UIVC, animated: Bool)
    func push(_ controller: UIVC, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
}

extension Router {
    func present(_ controller: UIVC, animated: Bool = true) {
        presenter?.present(controller, animated: animated)
    }
    func push(_ controller: UIVC, animated: Bool = true) {
        presenter?.push(controller)
    }
    func pop(animated: Bool = true) {
        presenter?.popViewController(animated: animated)
    }
    func dismiss(animated: Bool = true) {
        presenter?.dismiss(animated: animated)
    }
}
