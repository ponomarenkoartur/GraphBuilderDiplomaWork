//
//  UIStoryboard + extension.swift
//  Agate
//
//  Created by Developer on 8/13/19.
//  Copyright © 2019 Agate. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// The uniform place where we state all the storyboard we have in our application
    
    enum Storyboard: String {
        case main
        case launchScreen
        
        var filename: String { return rawValue.firstCapitalized }
    }
    
    
    // MARK: - Convenience Initializers
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    
    // MARK: - Class Functions
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil)
        -> UIStoryboard {
        UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
}

// MARK: - StoryboardIdentifiable

protocol StoryboardIdentifiable {
    static var storyboardID: String { get }
}

extension UIViewController: StoryboardIdentifiable {}

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardID: String { String(describing: self) }
}


