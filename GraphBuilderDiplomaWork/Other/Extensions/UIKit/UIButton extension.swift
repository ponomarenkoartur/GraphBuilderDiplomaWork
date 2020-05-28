//
//  UIButton extension.swift
//  LimoDad
//
//  Created by artur_ios on 07.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit

extension UIButton {
    func setImage(_ image: UIImage?, animated: Bool = false) {
        setImage(image, for: .normal)
        if animated {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.layer.add(transition, forKey: nil)
        }
    }
    
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }
    
    func setAttributedTitle(_ title: NSAttributedString?) {
        setAttributedTitle(title, for: .normal)
    }
    
    func setTitleColor(_ color: UIColor?) {
        setTitleColor(color, for: .normal)
    }
    
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
