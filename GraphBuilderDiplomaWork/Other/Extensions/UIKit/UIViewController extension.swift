//
//  UIViewController extension.swift
//  LimoDad
//
//  Created by artur_ios on 05.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit


// MARK: - Alert presentation

extension UIViewController {
    func presentOkAlert(title: String? = nil, message: String? = nil,
                        completion: @escaping () -> Void = {}) {
        let alert = AlertBuilder(title: title, message: message)
            .addOkButton() { _ in completion() }
            .build()
        alert.view.tintColor = UIColor(fromHexString: "50B7FF")
        present(alert, animated: true)
    }
    
    func showLoading(_ show: Bool) {
        show ? LoadingViewPresenter.shared.present() :
            LoadingViewPresenter.shared.hide()
    }
}

// MARK: - Storyboardable

extension UIViewController: Storyboardable {}


// MARK: - Google Signin Handling


extension BaseVC {
   
}
