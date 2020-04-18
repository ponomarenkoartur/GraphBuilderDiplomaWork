//
//  Storyboardable.swift
//  TestLoadView
//
//  Created by Developer on 9/12/19.
//  Copyright © 2019 Andrey Proskurin. All rights reserved.
//

import UIKit

protocol Storyboardable: class {
    typealias Storyboard = UIStoryboard.Storyboard

    static var viewControllerID: String { get }
}

extension Storyboardable where Self: UIViewController {

    static var viewControllerID: String {
        return String(describing: self)
    }

    static func fromStoryboard(_ storyboard: Storyboard = .main,
                               isInitial: Bool = false) -> Self {
        let storyboard = UIStoryboard(storyboard: storyboard)

        let instantiatedVC = isInitial ? storyboard.instantiateInitialViewController() :
            storyboard.instantiateViewController(withIdentifier: viewControllerID)

        guard let resultVC = instantiatedVC else {
            fatalError("Could not instantiate view controller with id: \(viewControllerID)")
        }
        
        guard let castedVC = resultVC as? Self else {
            fatalError("Could not cast view controller of type \(type(of: resultVC)) to \(Self.description())")
        }

        return castedVC
    }
}
