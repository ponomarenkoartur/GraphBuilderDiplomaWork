//
//  LoadingViewPresenter.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 26.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit


class LoadingViewPresenter {
    

    // MARK: - Singleton
    
    static var shared = LoadingViewPresenter()
    private init() {}
    
    
    // MARK: - Properties
    
    private var animation: [UIImage] {
        var textures = [UIImage]()
        for i in 0...29  {
            textures.append(UIImage(named: "circle_\(i)")!)
        }
        return textures
    }
    
    private lazy var loadView: UIView? = {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        let loadView = UIView()
        loadView.frame = window.frame
        loadView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let loadingImageView = UIImageView()
        loadingImageView.frame = CGRect(x: loadView.center.x - 75,
                                        y: loadView.center.y - 75,
                                        width: 150, height: 150)
        loadingImageView.contentMode = .scaleAspectFit
        loadingImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingImageView.animationImages = animation
        loadingImageView.animationDuration = 1.3
        loadingImageView.startAnimating()
        
        loadView.addSubview(loadingImageView)
        
        return loadView
    }()
    
    private var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    
    // MARK: - API Methods
    
    func hide() {
        loadView?.removeFromSuperview()
    }
    
    func present(isReload: Bool = false) {
        loadView?.backgroundColor = isReload ? UIColor.black :
            UIColor.black.withAlphaComponent(0.8)
        if let loadView = loadView {
            window?.addSubview(loadView)
        }
    }
}

